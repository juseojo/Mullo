//
//  Main_ViewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class Main_ViewController: UIViewController {

	var main_view = Main_View()
	let main_viewModel = Main_viewModel()
	private let disposeBag = DisposeBag()
	var cell_height_array = [CGFloat]()
	var isLoadingData = false

	override func viewDidLoad() {
		super.viewDidLoad()

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
		main_viewModel.get_data(index: 0)

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
		main_viewModel.get_data(index: 0)
		isLoadingData = true
		main_view.post_collectionView.refreshControl!.endRefreshing()
		main_view.post_collectionView.reloadData()
	}

	func bind_collectionView()
	{
		main_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to: main_view.post_collectionView.rx.items(cellIdentifier: "post", cellType: Post_collectionView_cell.self)) { row, item, cell in
				cell.name_label.text = item.name_text
				cell.time_label.text = item.time_text
				cell.post_textView.text = item.post_text
				
				let buttons_text = item.choice_text.substr(seperater: "|" as Character)

				if buttons_text.count == 3
				{
					cell.add_third_button(button_text: buttons_text[2])
				}
				else if buttons_text.count == 4
				{
					cell.add_third_button(button_text: buttons_text[2])
					cell.add_fourth_button(button_text: buttons_text[3])
				}

				cell.first_button.setTitle(buttons_text[0], for: .normal)
				cell.second_button.setTitle(buttons_text[1], for: .normal)
			}
			.disposed(by: self.disposeBag)
	}

	private func save_cell_height(item: Post_cell_data)
	{
		let choice_view_height = item.choice_text.filter { $0 == "|" as Character }.count * 40

		let height =
		(self.calculateHeight(for: item.name_text, width: screen_width - 20)) +
		(self.calculateHeight(for: item.post_text, width: screen_width - 20)) +
		CGFloat(choice_view_height) + 100

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

		if cell_height_array.count == 0 || cell_height_array.count <= indexPath.row
		{
			print("cell_height_array not ready")
			return CGSize(width: screen_width, height: 400)
		}

		return CGSize(width: screen_width, height: cell_height_array[indexPath.row])
	}

	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		let post_num = collectionView.numberOfItems(inSection: 0)

		if indexPath.row == post_num - 1 && !isLoadingData && post_num % 7 == 0{
			isLoadingData = true
			main_viewModel.get_data(index: (post_num) / 7)
		}
		isLoadingData = false
	}
}


