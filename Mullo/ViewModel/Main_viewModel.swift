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
	private let subject = BehaviorSubject<[Post_cell_data]>(value: [])
	var items: Observable<[Post_cell_data]> {
		return subject.compactMap { $0 }
	}

	final func get_data(index: Int, complete_handler: @escaping (Bool) -> Void) {
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

	final func cell_setting(cell: Post_collectionView_cell, item: Post_cell_data)
	{
		// data setting ( item to cell )
		cell.name_label.text = item.name
		cell.time_label.text = item.time
		cell.post_textView.text = item.post
		cell.choice_button_vote_count = item.choice_count.substr(seperater: "|" as Character).map{ Int($0)! }
		cell.post_num = Int(item.post_num)
		cell.buttons = [cell.first_button, cell.second_button, cell.third_button, cell.fourth_button]

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

		// Case : post was Selected
		if wasSelected != nil
		{
			var num = 0

			for button in cell.buttons
			{
				guard (button.superview != nil) else { return }
				button.isEnabled = false
				selecting_buttons(isSelected: (num == wasSelected?.selected_choice), index: num, cell: cell, total_count: cell.choice_button_vote_count.reduce(0) { return $0 + $1 })
				num += 1
			}
		}

		// tap event - choice buttons
		for button in cell.buttons
		{
			guard (button.superview != nil) else { return }
			button.rx.tap
				.bind { [weak self] in
					self?.choice_button_touch(touched_button: button, cell: cell)
				}.disposed(by: cell.disposeBag)
		}
	}

	
	private func choice_button_touch(touched_button: UIButton, cell: Post_collectionView_cell) {

		var num = 0
		var selected_button_num = -1
		var total_vote_count = 0

		// Find selected button num for saveing and send to server
		for button in cell.buttons
		{
			if button.superview == nil {
				continue
			}
			button.isEnabled = false

			if button == touched_button {
				cell.choice_button_vote_count[num] = cell.choice_button_vote_count[num] + 1
				selected_button_num = num

				// Save selected button inform at realm
				let realm = try! Realm()
				let mullo_DB = realm.objects(Mullo_DB.self).first

				if (mullo_DB == nil)
				{
					try! realm.write{
						let new_mullo_DB = Mullo_DB()
						realm.add(new_mullo_DB)
					}
					print("mullo db create")
				}
				let selected_post = Selected_post()
				try! realm.write{
					selected_post.post_num = cell.post_num
					selected_post.selected_choice = num
					mullo_DB!.selected_posts.append(selected_post)
				}

				// vote to server
				let parameters = ["choice_num" : num,
								  "post_num" : cell.post_num]
				vote_to_server(parameters: parameters)
			}
			total_vote_count += cell.choice_button_vote_count[num]
			num += 1
		}

		// Add layout for buttons
		for i in 0...(num - 1)
		{
			i == selected_button_num ? 
			selecting_buttons(isSelected: true, index: i, cell: cell, total_count: total_vote_count):
			selecting_buttons(isSelected: false, index: i, cell: cell, total_count: total_vote_count)
		}
	}

	final func vote_to_server(parameters: Parameters)
	{
		AF.request(
			"https://\(host)/vote_choice",
			method: .post,
			parameters: parameters,
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("vote success")
			case .failure(let error):
				print("Error: \(error)")
			}
		}
	}

	// Change layout - selecting buttons
	func selecting_buttons(isSelected: Bool, index: Int, cell: Post_collectionView_cell, total_count: Int)
	{
		if isSelected
		{
			let touched_button_count = cell.choice_button_vote_count[index]

			cell.choice_view.addSubview(cell.touched_button_background_view)
			cell.touched_button_background_view.snp.makeConstraints { make in
				make.top.left.bottom.equalTo(cell.buttons[index])
				make.width.equalTo((Double(touched_button_count) / Double(total_count)) * (Double(screen_width) - 20))
			}
			cell.choice_view.bringSubviewToFront(cell.buttons[index])

			let percent_label = UILabel()

			cell.choice_view.addSubview(percent_label)
			percent_label.text = String(round((Double(touched_button_count) / Double(total_count)) * 100)) + " %"
			percent_label.snp.makeConstraints { make in
				make.top.bottom.equalTo(cell.buttons[index])
				make.right.equalTo(cell.buttons[index]).inset(5)
			}
		}
		else
		{
			let background_view = UIView()
			let button_count = cell.choice_button_vote_count[index]

			background_view.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
			background_view.layer.borderWidth = 1.5
			background_view.clipsToBounds = true

			cell.choice_view.addSubview(background_view)
			cell.choice_view.bringSubviewToFront(cell.buttons[index])
			print("\(cell.post_num) : \(Double(button_count)) / \(Double(total_count))")
			background_view.snp.makeConstraints { make in
				make.top.left.bottom.equalTo(cell.buttons[index])
				make.width.equalTo((Double(button_count) / Double(total_count)) * (Double(screen_width) - 20))
			}

			let percent_label = UILabel()

			cell.choice_view.addSubview(percent_label)
			percent_label.text = String(round((Double(button_count) / Double(total_count)) * 100)) + " %"
			percent_label.snp.makeConstraints { make in
				make.top.bottom.equalTo(cell.buttons[index])
				make.right.equalTo(cell.buttons[index]).inset(5)
			}
		}
	}

	func remove_all()
	{
		self.subject.onNext([])
	}
}
