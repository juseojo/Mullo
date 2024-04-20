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
		get_data()
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] results in
				self?.subject.onNext(results)
			})
			.disposed(by: disposeBag)
	}

	private func get_data() -> Observable<[Post_cell_data]>  {
		return Observable<[Post_cell_data]>.create { observer in
			AF.request(
				"http://\(host)/get_post?offset=0",
				method: .get,
				encoding: URLEncoding.httpBody).responseJSON() { response in
				switch response.result {
				case .success:
					if let data = try! response.result.get() as? [[String]] {
						var result = [Post_cell_data]()

						for source in data
						{
							print(source)
							let post_cell_data = Post_cell_data()

							post_cell_data.name_text = source[0]
							post_cell_data.time_text = source[1]
							post_cell_data.post_text = source[2]
							post_cell_data.choice_text = source[3]

							result.append(post_cell_data)
						}
						print(result)
						// 실제 데이터 전달
						self.subject.onNext(result)
						// 완료 처리
						self.subject.onCompleted()
					}
				case .failure(let error):
					print("Error: \(error)")
					self.subject.onError(error)
				}
			}
			return self.subject.asObservable().subscribe()
		}
	}
}
