//
//  Write_post_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit

import Alamofire
import RxSwift
import SnapKit

final class Write_post_viewModel
{
	private let disposeBag = DisposeBag()
	let subject = BehaviorSubject<[UIImage]>(value: [])
	var items: Observable<[UIImage]> {
		return subject.compactMap { $0 }
	}

	func add_image(image: UIImage)
	{
		do {
			var current_images = try subject.value()
			current_images.insert(image, at: 0)
			subject.onNext(current_images)
		} catch {
			print("Error getting current images: \(error)")
		}
	}
}
