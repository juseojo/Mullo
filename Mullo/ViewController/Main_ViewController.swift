//
//  Main_ViewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import RealmSwift
import SnapKit
import Kingfisher

final class Main_ViewController: UIViewController {

	var main_view = Main_View()
	let main_viewModel = Main_viewModel()
	private let disposeBag = DisposeBag()
	var cell_height_array = [CGFloat]()
	var isLoadingData = false

	override func viewDidLoad() {
		super.viewDidLoad()
		isServer_ok(vc: self)

		//basic setting
		view.backgroundColor = UIColor(named: "NATURAL")
		self.navigationController?.isNavigationBarHidden = true

		//delegate
		main_view.post_collectionView.rx.setDelegate(self)
			.disposed(by: disposeBag)

		//layout
		self.view.addSubview(main_view)
		main_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}

		//button event set
		main_view.write_button.rx.tap
			.bind{
				print("write_button_touch")
				self.write_button_touch()
			}.disposed(by: disposeBag)

		//for refresh
		let refresh_controll : UIRefreshControl = UIRefreshControl()
		refresh_controll.addTarget(self, action: #selector(self.refresh_posts), for: .valueChanged)
		main_view.post_collectionView.refreshControl = refresh_controll

		//binding and get data
		bind_collectionView()
		main_viewModel.get_data(index: 0) { isSuccess in
			print("get_post_success")
		}

		//dynamic cell height
		main_viewModel.items
			.subscribe(onNext: { cell_dataSet in
				if (cell_dataSet.isEmpty == false) {
					self.cell_height_array.removeAll()
					for cell_data in cell_dataSet {
						self.save_cell_height(item: cell_data)
					}
					self.main_view.post_collectionView.reloadData()
				}
			}).disposed(by: self.disposeBag)
	}

	func write_button_touch()
	{
		let vc = Write_post_viewController()

		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc func refresh_posts(){

		main_viewModel.remove_all()
		main_viewModel.get_data(index: 0) { isSuccess in
			print("get_post_success")
		}
		isLoadingData = true
		main_view.post_collectionView.refreshControl!.endRefreshing()
		main_view.post_collectionView.reloadData()
	}

	func bind_collectionView()
	{
		main_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: main_view.post_collectionView.rx.items(
				cellIdentifier: Post_collectionView_cell.identifier, cellType: Post_collectionView_cell.self)) { row, item, cell in

					cell.name_label.text = item.name
					cell.time_label.text = item.time
					cell.post_textView.text = item.post
					cell.choice_button_vote_count = item.choice_count.substr(seperater: "|" as Character)
					cell.post_num = Int(item.post_num)

					let buttons_text = item.choice.substr(seperater: "|" as Character)

					if buttons_text.count == 3
					{
						cell.add_third_button(button_text: buttons_text[2])
					}
					else if buttons_text.count == 4
					{
						cell.add_third_button(button_text: buttons_text[2])
						cell.add_fourth_button(button_text: buttons_text[3])
					}

					let images_url = item.pictures.substr(seperater: "|" as Character)

					if (images_url[0] != "")
					{
						cell.subject.onNext(images_url)
					}
					cell.first_button.setTitle(buttons_text[0], for: .normal)
					cell.second_button.setTitle(buttons_text[1], for: .normal)

					//realm for selected post
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

					//if post was Selected
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
				.disposed(by: self.disposeBag)
	}

	private func save_cell_height(item: Post_cell_data)
	{
		let choice_view_height = item.choice.filter { $0 == "|" as Character }.count * 30

		var height =
		(self.calculateHeight(for: item.name, width: screen_width - 20)) +
		(self.calculateHeight(for: item.post, width: screen_width - 20)) +
		screen_height * 0.2 + 20 +
		CGFloat(choice_view_height) + 100

		if item.pictures == ""
		{
			height = height - screen_height * 0.2
		}

		cell_height_array.append(height)
	}

	private func calculateHeight(for text: String, width: CGFloat) -> CGFloat 
	{
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))

		label.font = UIFont(name: "GillSans-SemiBold", size: 15)
		label.numberOfLines = 0
		label.text = text
		label.sizeToFit()

		return label.frame.height
	}
}

extension Main_ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		//for dynamic height
		if cell_height_array.count == 0 || cell_height_array.count <= indexPath.row
		{
			print("cell_height_array not ready")
			return CGSize(width: screen_width, height: 400)
		}

		return CGSize(width: screen_width, height: cell_height_array[indexPath.row])
	}

	//for infinity scroll
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		let post_num = collectionView.numberOfItems(inSection: 0)

		if indexPath.row == post_num - 1 && !isLoadingData && post_num % 7 == 0
		{
			isLoadingData = true
			main_viewModel.get_data(index: (post_num) / 7) { isSuccess in
				if isSuccess == false
				{
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						self.isLoadingData = false
					}
				}
				else
				{
					self.isLoadingData = false
				}
			}
		}
	}
}


