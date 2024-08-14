//
//  Setting_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 8/10/24.
//

import UIKit
import CryptoKit
import Alamofire

final class Setting_viewModel {

	final func isAppleID(completed_handler : @escaping (String) -> ())
	{
		AF.request(
			"https://\(host)/isAppleID",
			method: .post,
			parameters: ["name" : UserDefaults.standard.string(forKey: "name")!,],
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				if response.value?["result"] == "true" {
					completed_handler("true")
				}
				else if response.value?["result"] == "false" {
					completed_handler("false")
				}
				else {
					completed_handler("error")
				}
			case .failure(let error):
				print("Error: \(error)")
				completed_handler("error")
			}
		}
	}

	final func revoke_appleID()
	{
		AF.request(
			"https://\(host)/revoke",
			method: .post,
			parameters: ["name" : UserDefaults.standard.string(forKey: "name")!,],
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("revoke success")
			case .failure(let error):
				print("Error: \(error)")
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
		}
	}

	final func delete_DB()
	{
		AF.request(
			"https://\(host)/deleteDB",
			method: .post,
			parameters: ["name" : UserDefaults.standard.string(forKey: "name")!,],
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("delete DB success")
				UserDefaults.standard.set(nil, forKey: "name")
			case .failure(let error):
				print("Error: \(error)")
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
		}
	}
}
