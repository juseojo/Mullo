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
			}
		}
	}

	final func add_comment(parameters: Parameters)
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
				print("posting success")
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}

	final func get_comments(index: Int, post_num: Int, isSortByPopular: Bool, complete_handler: @escaping (Bool) -> Void)
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
						complete_handler(false)
						return
					}
					var comments_dataSet = try self.subject.value()
					comments_dataSet.append(contentsOf: data)
					self.subject.onNext(comments_dataSet)
					complete_handler(true)
				} catch {
					print("-- Error at getting comments --\n \(error)")
				}
			case .failure(let error):
				complete_handler(false)
				print("Error: \(error)")
				//self.subject.onError(error)
			}
		}
	}

	final func cell_setting(cell: Comments_collectionView_cell, item: Comments_cell_data)
	{
		// insert data
		cell.comment_num = item.comment_num
		cell.comment_label.text = item.comment
		cell.name_label.text = item.name
		cell.time_label.text = item.time
		cell.up_button.setTitle(" " + String(item.up_count), for: .normal)

		// make dynamic height
		let nameLabel_newSize = cell.name_label.sizeThatFits(
			CGSize(width: screen_width, height: screen_height))
		let commentLabel_newSize = cell.comment_label.sizeThatFits(
			CGSize(width: screen_width, height: screen_height))

		cell.nameLabel_width_setting(width: Int(nameLabel_newSize.width))
		cell.commentLabel_height_setting(height: Int(commentLabel_newSize.height) + 20)

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
	}

	func remove_all()
	{
		self.subject.onNext([])
	}
}
