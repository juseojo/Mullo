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

		main_view.inform_button.rx.tap
			.bind{
				self.inform_button_touch()
			}.disposed(by: disposeBag)

		//for refresh
		let refresh_controll : UIRefreshControl = UIRefreshControl()
		refresh_controll.addTarget(self, action: #selector(self.refresh_posts), for: .valueChanged)
		main_view.post_collectionView.refreshControl = refresh_controll

		//binding and get data
		bind_collectionView()
		main_viewModel.get_data(index: 0)

		//dynamic cell height
		main_viewModel.items
			.subscribe(onNext: { [weak self] cell_dataSet in
				if (cell_dataSet.isEmpty == false) {
					self!.cell_height_array.removeAll()
					for cell_data in cell_dataSet {
						self!.cell_height_array.append(self!.main_viewModel.calculate_cell_height(item: cell_data))
					}
				}
			}).disposed(by: self.disposeBag)
	}

	func write_button_touch()
	{
		let vc = Write_post_viewController()

		self.navigationController?.pushViewController(vc, animated: true)
	}

	func inform_button_touch()
	{
		let vc = Inform_viewController()

		self.navigationController?.pushViewController(vc, animated: true)
	}

	@objc func refresh_posts()
	{
		main_viewModel.remove_all()
		main_viewModel.get_data(index: 0)
		self.isLoadingData = false
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
						}.disposed(by: cell.disposeBag)
				}
				.disposed(by: self.disposeBag)
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
			main_viewModel.get_data(index: (post_num) / 7)
			self.isLoadingData = false
		}
	}
}


