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
					// cell setting
					self.main_viewModel.cell_setting(cell: cell, item: item)
					// comments button rx binding
					cell.comments_button.rx.tap
						.bind{

							let comments_vc = Comments_viewController()
							comments_vc.modalPresentationStyle = .overCurrentContext
							comments_vc.post_num = item.post_num
							self.present(comments_vc, animated: true, completion: nil)
							UIView.animate(withDuration: 0.3) {
								self.main_view.color_view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
							}
							comments_vc.completion_handler = {
								UIView.animate(withDuration: 0.3) {
									self.main_view.color_view.backgroundColor = UIColor.black.withAlphaComponent(0)
								}
							}
						}.disposed(by: self.disposeBag)
				}
				.disposed(by: self.disposeBag)
	}

	private func save_cell_height(item: Post_cell_data)
	{
		let choice_view_height = item.choice.filter { $0 == "|" as Character }.count * 30

		var height =
		calculate_height(text: item.name, font: UIFont(name: "GillSans-SemiBold", size: 15)!, width: screen_width - 20) +
		calculate_height(text: item.post, font: UIFont(name: "GillSans-SemiBold", size: 15)!, width: screen_width - 20) +
		screen_height * 0.2 + 20 +
		CGFloat(choice_view_height) + 100

		if item.pictures == ""
		{
			height = height - screen_height * 0.2
		}

		cell_height_array.append(height)
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


