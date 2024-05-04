//
//  Main_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 4/19/24.
//

import UIKit

import Alamofire
import RxSwift
import SnapKit

final class Main_viewModel
{
	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Post_cell_data]>(value: [])
	var items: Observable<[Post_cell_data]> {
		return subject.compactMap { $0 }
	}

	func get_data(index: Int, complete_handler: @escaping (Bool) -> Void) {
		AF.request(
			"http://\(host)/get_post?offset=\(index)",
			method: .get,
			encoding: URLEncoding.queryString)
				.validate(statusCode: 200..<300)
				.validate(contentType: ["application/json"])
				.responseDecodable(of: [[String]].self) { response in
			switch response.result {
			case .success:	
				do {
					let data = try response.result.get()
					//data classify
					let classified_data = (data.map { source -> Post_cell_data in
						return Post_cell_data(
							name_text: source[0],
							time_text: source[1],
							post_text: source[2],
							choice_text: source[3],
							choice_count: source[4],
							picture_text: source[5]
						)
					})
					if classified_data.isEmpty
					{
						complete_handler(false)
						return
					}
					var post_dataSet = try self.subject.value()
					post_dataSet.append(contentsOf: classified_data)
					self.subject.onNext(post_dataSet)
					complete_handler(true)
				} catch {
					print("Error getting current images: \(error)")
				}
			case .failure(let error):
				complete_handler(false)
				print("Error: \(error)")
				self.subject.onError(error)
			}
		}
	}

	func remove_all()
	{
		self.subject.onNext([])
	}
}
