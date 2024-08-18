//
//  Comments_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 7/14/24.
//

import Alamofire
import RxSwift
import RealmSwift

final class Comments_viewModel {

	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Comments_cell_data]>(value: [])
	var items: Observable<[Comments_cell_data]> {
		return subject.compactMap { $0 }
	}

	final func count_up_comment(parameters: Parameters)
	{
		AF.request(
			"https://\(host)/plus_up_count",
			method: .post,
			parameters: parameters,
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("up_count success")
			case .failure(let error):
				print("Error: \(error)")
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
		}
	}

	final func add_comment(parameters: Parameters, completed_handler: @escaping () -> (Void))
	{
		AF.request(
			"https://\(host)/add_comment",
			method: .post,
			parameters: parameters,
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("add comment success")
				completed_handler()
			case .failure(let error):
				print("Error: \(error)")
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
				completed_handler()
			}
		}
	}

	final func get_comments(index: Int, post_num: Int, isSortByPopular: Bool)
	{
		var url_text: String

		if isSortByPopular {
			url_text = "https://\(host)/get_comments_byPopularity?offset=\(index)&post_num=\(post_num)"
		}
		else {
			url_text = "https://\(host)/get_comments_byRecently?offset=\(index)&post_num=\(post_num)"
		}
		AF.request(
			url_text,
			method: .get,
			encoding: URLEncoding.queryString)
				.validate(statusCode: 200..<300)
				.validate(contentType: ["application/json"])
				.responseDecodable(of: [Comments_cell_data].self) { response in
			switch response.result {
			case .success:
				do {
					let data = try response.result.get()
					if data.isEmpty
					{
						print("comment empty")
						return
					}
					var comments_dataSet = try self.subject.value()
					comments_dataSet.append(contentsOf: data)
					self.subject.onNext(comments_dataSet)

				} catch {
					print("-- Error at getting comments --\n \(error)")
					AlertHelper.showAlert(
						title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
				}
			case .failure(let error):

				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
				print("Error: \(error)")
			}
		}
	}

	final func cell_setting(cell: Comments_collectionView_cell, item: Comments_cell_data)
	{
		// insert data
		cell.comment_num = item.comment_num
		cell.comment_label.text = item.comment
		cell.name_label.text = item.name
		cell.time_label.text = time_diff(past_date: item.time)
		cell.up_button.setTitle(" " + String(item.up_count), for: .normal)

		cell.comment_label.setLineSpacing(spacing: 5.0)
		// make dynamic height
		let nameLabel_newSize = cell.name_label.sizeThatFits(
			CGSize(width: screen_width, height: screen_height))
		let commentLabel_newHeight = calculate_height(
			text: item.comment, font: cell.comment_label.font, width: screen_width - 20, line_space: 5.0)

		cell.nameLabel_width_setting(width: nameLabel_newSize.width)
		cell.commentLabel_height_setting(height: commentLabel_newHeight)

		// realm for selected up button
		let realm = try! Realm()
		var comment_DB = realm.objects(Comment_DB.self).first

		if comment_DB == nil
		{
			try! realm.write{
				let new_comment_DB = Comment_DB()
				realm.add(new_comment_DB)
			}
			print("comment db create")
			comment_DB = realm.objects(Comment_DB.self).first
		}

		let wasSelected = comment_DB?.choose_upButtons.where {
			$0.comment_num == cell.comment_num
		}.first

		if wasSelected != nil{
			cell.up_button.isSelected.toggle()
		}

		// tab event - up button
		cell.up_button.rx.tap
			.bind{ [weak self] in
				if wasSelected != nil || cell.up_button.isSelected
				{
					AlertHelper.showAlert(title: "알림", message: "이미 누른 좋아요입니다.", button_title: "확인", handler: nil)
				}
				else
				{
					var up_count = Int((cell.up_button.titleLabel!.text!.trimmingCharacters(in: .whitespacesAndNewlines)))

					up_count! += 1
					cell.up_button.setTitle(" \(String(describing: up_count!))", for: .selected)
					cell.up_button.isSelected.toggle()
					let choose_upButton = Choose_upButton(comment_num: cell.comment_num)
					try! realm.write{
						comment_DB!.choose_upButtons.append(choose_upButton)
					}
					let parameters = [ "comment_num" : cell.comment_num ]
					self!.count_up_comment(parameters: parameters)
				}
			}.disposed(by: cell.cell_disposeBag)

		// tap event - report button
		cell.report_button.rx.tap.bind { [weak self] in
			let alert = UIAlertController(
				title: "신고", message: "신고 항목을 선택해주세요.", preferredStyle: .actionSheet)
			let sexual_action = UIAlertAction(title: "성적인 콘텐츠", style: .default) { _ in
				self!.report_to_server(type: 0, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let violent_action = UIAlertAction(title: "폭력적 또는 혐오스러운 콘텐츠", style: .default) { _ in
				self!.report_to_server(type: 1, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let bother_action = UIAlertAction(title: "괴롭힘", style: .default) { _ in
				self!.report_to_server(type: 2, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let noxious_action = UIAlertAction(title: "유해한 콘텐츠", style: .default) { _ in
				self!.report_to_server(type: 3, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let terror_action = UIAlertAction(title: "테러 조장", style: .default) { _ in
				self!.report_to_server(type: 4, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let advertisement_action = UIAlertAction(title: "도배 및 광고", style: .default) { _ in
				self!.report_to_server(type: 5, content: cell.comment_label.text!, name: cell.name_label.text!)
			}
			let cancel_action = UIAlertAction(title: "취소하기", style: .cancel)

			alert.addAction(sexual_action)
			alert.addAction(violent_action)
			alert.addAction(bother_action)
			alert.addAction(noxious_action)
			alert.addAction(terror_action)
			alert.addAction(advertisement_action)
			alert.addAction(cancel_action)

			AlertHelper.showAlert(alert: alert)
		}.disposed(by: cell.cell_disposeBag)
	}

	private func report_to_server(type: Int, content: String, name: String)
	{
		let parameters = [ "type" : type, "content" : content, "name" : name ] as [String : Any]

		AF.request(
			"https://\(host)/report",
			method: .post,
			parameters: parameters,
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("report success")
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}

	func remove_all()
	{
		self.subject.onNext([])
	}
}
