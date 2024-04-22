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
	var cell_height_array = [CGFloat]()

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor(named: "NATURAL")

		//main_view.post_collectionView.delegate = self
		main_view.post_collectionView.rx.setDelegate(self)
			.disposed(by: disposeBag)
		self.view.addSubview(main_view)
		main_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}

		bind_collectionView()
		main_viewModel.get_cell_data()

		main_viewModel.items
			.subscribe(onNext: { cell_dataSet in
				if (cell_dataSet.isEmpty == false) {
					for cell_data in cell_dataSet {
						self.save_cell_height(item: cell_data)
					}
					self.main_view.post_collectionView.reloadData()
				}
			})
	}

	func bind_collectionView()
	{
		main_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: main_view.post_collectionView.rx.items(cellIdentifier: "post", cellType: Post_collectionView_cell.self)) { row, item, cell in
				cell.name_label.text = item.name_text
				cell.time_label.text = item.time_text
				cell.post_textView.text = item.post_text
				cell.first_button.setTitle(item.choice_text, for: .normal)
				cell.second_button.setTitle(item.choice_text, for: .normal)
			}
			.disposed(by: self.disposeBag)
	}

	private func save_cell_height(item: Post_cell_data)
	{
		let choice_view_height = item.choice_text.filter { $0 == "|" as Character }.count * 20

		let height =
		(self.calculateHeight(for: item.name_text, width: screen_width - 20)) +
		(self.calculateHeight(for: item.post_text, width: screen_width - 20)) +
		CGFloat(choice_view_height) + 100

		cell_height_array.append(height)
	}

	private func calculateHeight(for text: String, width: CGFloat) -> CGFloat {
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))

		label.numberOfLines = 0
		label.text = text
		label.sizeToFit()

		return label.frame.height
	}
}

extension Main_ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		print(indexPath.row)


		if cell_height_array.count == 0 || cell_height_array.count <= indexPath.row
		{
			print("cell_height_array not ready")
			return CGSize(width: screen_width, height: 400)
		}
		return CGSize(width: screen_width, height: cell_height_array[indexPath.row])
		//return CGSize(width: screen_width, height: screen_height/2)
	}
}


