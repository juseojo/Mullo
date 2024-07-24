//
//  Comments_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 7/14/24.
//

import Alamofire
import RxSwift

final class Comments_viewModel {

	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Comments_cell_data]>(value: [])
	var items: Observable<[Comments_cell_data]> {
		return subject.compactMap { $0 }
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
		cell.comment_label.text = item.comment
		cell.name_label.text = item.name
		cell.time_label.text = item.time
		cell.up_button.setTitle(String(item.up_count), for: .normal)

		let commentLabel_newSize = cell.comment_label.sizeThatFits(
			CGSize(width: screen_width, height: screen_height))
		let nameLabel_newSize = cell.name_label.sizeThatFits(
			CGSize(width: screen_width, height: screen_height))

		cell.commentLabel_height_setting(height: Int(commentLabel_newSize.height))
		cell.nameLabel_width_setting(width: Int(nameLabel_newSize.width))
	}
}
