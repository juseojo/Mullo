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
	var completion_handler: (() -> Void)?
	var post_num = -1

	override func viewDidLoad() {

		self.navigationController?.isNavigationBarHidden = true

		comments_view.comment_textView.delegate = self

		comments_view.close_button.rx.tap
			.bind {
				self.dismiss(animated: true)
			}.disposed(by: disposeBag)

		bind_collectionView()

		comments_view.comment_add_button.rx.tap
			.bind {
				let parameters: [String:String] = [
					"post_num" : String(self.post_num),
					"name" : UserDefaults.standard.string(forKey: "name") ?? "none",
					"time" : get_time_now(),
					"comment" : self.comments_view.comment_textView.text
				]
				self.comments_viewModel.add_comment(parameters: parameters)
			}.disposed(by: disposeBag)

		// get first comment data
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

	func bind_collectionView()
	{
		comments_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: comments_view.comments_collectionView.rx.items(
				cellIdentifier: Comments_collectionView_cell.identifier, cellType: Comments_collectionView_cell.self)) { row, item, cell in
					// cell setting
					self.comments_viewModel.cell_setting(cell: cell, item: item)
				}.disposed(by: self.disposeBag)
	}
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
