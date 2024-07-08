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
import RealmSwift

final class Main_viewModel
{
	private let disposeBag = DisposeBag()
	private let subject = BehaviorSubject<[Post_cell_data]>(value: [])
	var items: Observable<[Post_cell_data]> {
		return subject.compactMap { $0 }
	}

	func get_data(index: Int, complete_handler: @escaping (Bool) -> Void) {
		AF.request(
			"https://\(host)/get_post?offset=\(index)",
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
				self.subject.onError(error)
			}
		}
	}

	func cell_setting(cell: Post_collectionView_cell, item: Post_cell_data)
	{
		// data setting ( item to cell )
		cell.name_label.text = item.name
		cell.time_label.text = item.time
		cell.post_textView.text = item.post
		cell.choice_button_vote_count = item.choice_count.substr(seperater: "|" as Character)
		cell.post_num = Int(item.post_num)

		// choice data parsing
		let buttons_text = item.choice.substr(seperater: "|" as Character)

		// buttons setting
		cell.first_button.setTitle(buttons_text[0], for: .normal)
		cell.second_button.setTitle(buttons_text[1], for: .normal)

		// buttons add
		if buttons_text.count == 3
		{
			cell.add_third_button(button_text: buttons_text[2])
		}
		else if buttons_text.count == 4
		{
			cell.add_third_button(button_text: buttons_text[2])
			cell.add_fourth_button(button_text: buttons_text[3])
		}

		// images data parsing
		let images_url = item.pictures.substr(seperater: "|" as Character)

		// image add
		if (images_url[0] != "")
		{
			cell.subject.onNext(images_url)
		}

		// realm for selected post
		let realm = try! Realm()
		var mullo_DB = realm.objects(Mullo_DB.self).first

		if mullo_DB == nil
		{
			try! realm.write{
				let new_mullo_DB = Mullo_DB()
				realm.add(new_mullo_DB)
			}
			print("mullo db create")
			mullo_DB = realm.objects(Mullo_DB.self).first
		}

		let wasSelected = mullo_DB?.selected_posts.where {
			$0.post_num == Int(item.post_num)
		}.first

		let buttons = [cell.first_button, cell.second_button, cell.third_button, cell.fourth_button]

		// Case : post was Selected
		if wasSelected != nil
		{
			var num = 0

			for button in buttons
			{
				guard (button.superview != nil) else { return }
				button.isEnabled = false
				cell.selecting_buttons(isSelected: (num == wasSelected?.selected_choice), index: num)
				num += 1
			}
		}
	}

	func remove_all()
	{
		self.subject.onNext([])
	}
}
