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

class Main_viewModel
{
	private var post_dataSet = [Post_cell_data]()
	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Post_cell_data]>(value: [])
	var items: Observable<[Post_cell_data]> {
		return subject.compactMap { $0 }
	}

	func get_data(index: Int) {
		AF.request(
			"http://\(host)/get_post?offset=\(index)",
			method: .get,
			encoding: URLEncoding.httpBody).validate().responseJSON() { response in
			switch response.result {
			case .success:				//get resource and convert to [[String]]
				if let data = try! response.result.get() as? [[String]] {
					//data classify
					self.post_dataSet.append(contentsOf: data.map { source -> Post_cell_data in
						return Post_cell_data(
							name_text: source[0],
							time_text: source[1],
							post_text: source[2],
							choice_text: source[3]
						)
					})
					self.subject.onNext(self.post_dataSet)
				}
			case .failure(let error):
				print("Error: \(error)")
				self.subject.onError(error)
			}
		}
	}

	func remove_all()
	{
		post_dataSet.removeAll()
	}
}
