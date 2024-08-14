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
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
		}
	}

	override func get_data(index: Int) {
		AF.request(
			"https://\(host)/get_my_post?offset=\(index)&name=\(UserDefaults.standard.string(forKey: "name") ?? "none")",
			method: .get,
			encoding: URLEncoding.queryString)
				.validate(statusCode: 200..<300)
				.validate(contentType: ["application/json"])
				.responseDecodable(of: [Post_cell_data].self) { response in
			switch response.result {
			case .success:
				do {
					let data = try response.result.get()
					var post_dataSet = try self.subject.value()

					post_dataSet.append(contentsOf: data)
					self.subject.onNext(post_dataSet)
				} catch {
					print("-- Error at getting current images --\n \(error)")
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
}
