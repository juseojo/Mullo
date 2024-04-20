//
//  Main_ViewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

import RxSwift
import RxCocoa

class Main_ViewController: UIViewController {

	let main_view = Main_View()
	let main_viewModel = Main_viewModel()
	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor(named: "NATURAL")

		self.view.addSubview(main_view)
		main_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}

		bind_collectionView()
		main_viewModel.get_cell_data()
	}

	func bind_collectionView()
	{
		main_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: main_view.post_collectionView.rx.items(cellIdentifier: "post", cellType: Post_collectionView_cell.self)) { row, item, cell in
				cell.name_label.text = item.name_text
				cell.time_label.text = item.time_text
				cell.post_textView.text = item.post_text
		  }
		  .disposed(by: self.disposeBag)
	}
}

extension Main_ViewController : UICollectionViewDelegateFlowLayout {

	func collectionView(
			  _ collectionView: UICollectionView,
			  layout collectionViewLayout: UICollectionViewLayout,
			  sizeForItemAt indexPath: IndexPath
		 ) -> CGSize {
		return CGSize(width: screen_width, height: screen_height / 2)
	}
}
