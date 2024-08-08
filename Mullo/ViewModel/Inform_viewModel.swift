//
//  Inform_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 8/6/24.
//

import UIKit
import Alamofire

final class Inform_viewModel: Main_viewModel {

	final func delete_post(post_num: Int)
	{
		AF.request(
			"https://\(host)/delete_post",
			method: .post,
			parameters: ["post_num" : post_num,],
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("delete success")
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}

	override func get_data(index: Int, complete_handler: @escaping (Bool) -> Void) {
		AF.request(
			"https://\(host)/get_my_post?offset=\(index)&name=\("주서조")", // have to change
			method: .get,
			encoding: URLEncoding.queryString)
				.validate(statusCode: 200..<300)
				.validate(contentType: ["application/json"])
				.responseDecodable(of: [Post_cell_data].self) { response in
			switch response.result {
			case .success:
				do {
					let data = try response.result.get()
					if data.isEmpty
					{
						complete_handler(false)
						return
					}
					var post_dataSet = try self.subject.value()
					post_dataSet.append(contentsOf: data)
					self.subject.onNext(post_dataSet)
					complete_handler(true)
				} catch {
					print("-- Error at getting current images --\n \(error)")
				}
			case .failure(let error):
				complete_handler(false)
				print("Error: \(error)")
			}
		}
	}
}
