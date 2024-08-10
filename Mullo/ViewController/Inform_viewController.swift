//
//  Inform_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/6/24.
//

import UIKit
import SnapKit
import RxSwift

final class Inform_viewController: UIViewController
{
	let inform_view = Inform_view()
	let inform_viewModel = Inform_viewModel()
	var cell_height_array = [CGFloat]()
	private let disposeBag = DisposeBag()
	var isLoadingData = false

	override func viewDidLoad() {

		// Basic setting
		view.backgroundColor = UIColor(named: "NATURAL")
		self.navigationController?.isNavigationBarHidden = true

		// Set delegate
		inform_view.myPost_collectionView.rx.setDelegate(self)
			.disposed(by: disposeBag)

		// Set basic layout
		self.view.addSubview(inform_view)
		inform_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(self.view)
		}

		// save dynamic cell height
		inform_viewModel.items
			.subscribe(onNext: { [weak self] cell_dataSet in
				if (cell_dataSet.isEmpty == false) {
					self!.cell_height_array.removeAll()
					for cell_data in cell_dataSet {
						self!.cell_height_array.append(self!.inform_viewModel.calculate_cell_height(item: cell_data))
					}
					// Reload posts, when VM get data
					self!.inform_view.myPost_collectionView.reloadData()
				}
			}).disposed(by: self.disposeBag)

		// tap event - back button
		inform_view.back_button.rx.tap.bind {
			self.navigationController?.popViewController(animated:true)
		}.disposed(by: disposeBag)

		// tap event - setting button
		inform_view.setting_button.rx.tap.bind {
			self.present(Setting_viewController(), animated: true)
		}.disposed(by: disposeBag)

		// Rx bind collection view
		bind_collectionView()

		// Get first data
		inform_viewModel.get_data(index: 0)
	}

	final func bind_collectionView()
	{
		inform_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: inform_view.myPost_collectionView.rx.items(
				cellIdentifier: MyPost_collectionView_cell.identifier, cellType: MyPost_collectionView_cell.self)) { row, item, cell in
					// cell setting
					self.inform_viewModel.cell_setting(cell: cell as! Post_collectionView_cell, item: item)
					
					// comments button rx binding
					cell.comments_button.rx.tap
						.bind{
							let comments_vc = Comments_viewController()
							comments_vc.modalPresentationStyle = .overCurrentContext
							comments_vc.post_num = item.post_num
							self.present(comments_vc, animated: true, completion: nil)
							UIView.animate(withDuration: 0.3) {
								self.inform_view.color_view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
							}
							comments_vc.completion_handler = {
								UIView.animate(withDuration: 0.3) {
									self.inform_view.color_view.backgroundColor = UIColor.black.withAlphaComponent(0)
								}
							}
						}.disposed(by: cell.disposeBag)

					// delete button rx binding
					cell.delete_button.rx.tap
						.bind{ [weak self] in
							let alert = UIAlertController(
								title: "경고", message: "정말로 게시글을 삭제하겠습니까?", preferredStyle: .alert)
							let yes_action = UIAlertAction(title: "예", style: .destructive) { _ in
								self!.inform_viewModel.delete_post(post_num: item.post_num)
								self!.inform_viewModel.remove_all()
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
									self!.inform_viewModel.get_data(index: 0)
									self!.inform_view.myPost_collectionView.reloadData()
								}
							}
							let no_action = UIAlertAction(title: "아니오", style: .cancel)

							alert.addAction(yes_action)
							alert.addAction(no_action)
							self!.present(alert, animated: true)
						}.disposed(by: cell.disposeBag)
				}
				.disposed(by: self.disposeBag)
	}
}

extension Inform_viewController: UICollectionViewDelegateFlowLayout {
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
			inform_viewModel.get_data(index: (post_num) / 7)
			self.isLoadingData = false
		}
	}
}
