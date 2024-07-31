//
//  Comments_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 7/5/24.
//

import UIKit
import SnapKit
import RxSwift

final class Comments_viewController: UIViewController
{
	let comments_view = Comments_view()
	let comments_viewModel = Comments_viewModel()
	var disposeBag = DisposeBag()
	var cell_height_array = [CGFloat]()
	var completion_handler: (() -> Void)?
	var post_num = -1

	override func viewDidLoad() {

		self.navigationController?.isNavigationBarHidden = true

		// delegate
		comments_view.comment_textView.delegate = self
		comments_view.comments_collectionView.delegate = self

		// rx binding
		rx_binding()

		// Get cell's dynamic height
		comments_viewModel.items
			.subscribe(onNext: { cell_dataSet in
				if (cell_dataSet.isEmpty == false) {
					self.cell_height_array.removeAll()
					for cell_data in cell_dataSet {
						self.save_cell_height(item: cell_data)
					}
					self.comments_view.comments_collectionView.reloadData()
				}
			}).disposed(by: self.disposeBag)
		
		// Get first comment data
		self.comments_viewModel.get_comments(index: 0, post_num: post_num, isSortByPopular: true) { isSuccess in
			if isSuccess == false {
				// Have to add error control
			}
		}

		view.addSubview(comments_view)
		comments_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(view)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		completion_handler!()
	}

	final func rx_binding()
	{
		// close_button binding
		comments_view.close_button.rx.tap
			.bind { [weak self] in
				self!.dismiss(animated: true)
			}.disposed(by: disposeBag)

		// comments_collectionView binding
		comments_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind( to: comments_view.comments_collectionView.rx.items(
				cellIdentifier: Comments_collectionView_cell.identifier,
				cellType: Comments_collectionView_cell.self)) { [weak self] row, item, cell in
					// cell setting
					self!.comments_viewModel.cell_setting(cell: cell, item: item)
				}.disposed(by: self.disposeBag)

		// comment_add_button binding
		comments_view.comment_add_button.rx.tap
			.bind { [weak self] in
				let parameters: [String:String] = [
					"post_num" : String(self!.post_num),
					"name" : UserDefaults.standard.string(forKey: "name") ?? "none",
					"time" : get_time_now(),
					"comment" : self!.comments_view.comment_textView.text
				]
				self!.comments_viewModel.add_comment(parameters: parameters)
				self!.comments_viewModel.remove_all()

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
				{
					self!.comments_viewModel.get_comments(
						index: 0, post_num: self!.post_num, isSortByPopular: false) { _ in
							// Have to add error control
						}
				}
				self!.comments_view.comment_textView.text = ""
				self!.view.endEditing(true)

			}.disposed(by: disposeBag)

		// popularSort_button binding
		comments_view.popularSort_button.rx.tap
			.bind { [weak self] in
				self!.comments_viewModel.remove_all()
				self!.comments_viewModel.get_comments(index: 0, post_num: self!.post_num, isSortByPopular: true) { isSuccess in
					if isSuccess == false {
						// Have to add error control
					}
				}
			}.disposed(by: disposeBag)

		// recentSort_button binding
		comments_view.recentSort_button.rx.tap
			.bind { [weak self] in
				self!.comments_viewModel.remove_all()
				self!.comments_viewModel.get_comments(index: 0, post_num: self!.post_num, isSortByPopular: false) { isSuccess in
					if isSuccess == false {
						// Have to add error control
					}
				}
			}.disposed(by: disposeBag)

	}

	final func save_cell_height(item: Comments_cell_data)
	{
		let height = calculate_height(
			text: item.comment, font: UIFont(name: "SeoulHangangM", size: 15)!, width: screen_width - 20) + 95

		cell_height_array.append(height)
	}

	final func bind_collectionView()
	{

	}
}

extension Comments_viewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		//for dynamic height
		if cell_height_array.count == 0 || cell_height_array.count <= indexPath.row
		{
			print("cell_height_array not ready")
			return CGSize(width: screen_width, height: 100)
		}

		return CGSize(width: screen_width, height: cell_height_array[indexPath.row])
	}

	//for infinity scroll
	/*
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
	 */
}

extension Comments_viewController: UITextViewDelegate {
	
	func textViewDidChange(_ textView: UITextView) {
		self.comments_view.placeholder_label.isHidden = !textView.text.isEmpty
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		self.comments_view.placeholder_label.isHidden = true
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		self.comments_view.placeholder_label.isHidden = !textView.text.isEmpty
	}
}
