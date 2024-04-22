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
	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Post_cell_data]>(value: [])
	var items: Observable<[Post_cell_data]> {
		return subject.asObservable()
	}

	func get_cell_data()
	{
		items
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] results in
				self?.subject.onNext(results)
			})
			.disposed(by: disposeBag)
		get_data()
	}

	private func get_data() {
		AF.request(
			"http://\(host)/get_post?offset=0",
			method: .get,
			encoding: URLEncoding.httpBody).validate().responseJSON() { response in
			switch response.result {
			case .success:				//get resource and convert to [[String]]
				if let data = try! response.result.get() as? [[String]] {
					//data classify
					let post_cell_dataSet = data.map { source -> Post_cell_data in
						return Post_cell_data(
							name_text: source[0],
							time_text: source[1],
							post_text: source[2],
							choice_text: source[3]
						)
					}
					self.subject.onNext(post_cell_dataSet)
					self.subject.onCompleted()
				}
			case .failure(let error):
				print("Error: \(error)")
				self.subject.onError(error)
			}
		}
	}
}
