//
//  Main_view.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

import SnapKit

class Main_View: UIView {

	private var header_view: UIView = {
		let header_view = UIView()

		header_view.backgroundColor = UIColor(named: "NATURAL")

		return header_view
	}()
	
	private var header_label: UILabel = {
		let header_label = UILabel()
		
		header_label.text = "멀로"
		header_label.tintColor = UIColor(named: "REVERSE_SYS")
		header_label.font = UIFont(name: "GillSans-SemiBold", size: 30)

		return header_label
	}()

	private var write_button: UIButton = {
		let write_button = UIButton()
		let button_image = UIImage(
			systemName: "square.and.pencil",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: head_height * 0.5, weight: .bold, scale: .large))
		write_button.setImage(button_image, for: .normal)
		write_button.tintColor = UIColor.black

		return write_button
	}()

	private var inform_button: UIButton = {
		let inform_button = UIButton()
		let button_image = UIImage(
			systemName: "person",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: head_height * 0.5, weight: .bold, scale: .large))

		inform_button.setImage(button_image, for: .normal)
		inform_button.tintColor = UIColor.black

		return inform_button
	}()

	var post_collectionView: UICollectionView = {
		let post_collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

		post_collectionView.backgroundColor = UIColor(named: "NATURAL")
		post_collectionView.register(
			Post_collectionView_cell.self, forCellWithReuseIdentifier: Post_collectionView_cell.identifier)

		return post_collectionView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		//layout
		addSubview(header_view)
		header_view.addSubview(header_label)
		header_view.addSubview(write_button)
		header_view.addSubview(inform_button)
		addSubview(post_collectionView)

		header_view.snp.makeConstraints { make in
			make.top.equalTo(self).inset(top_inset)
			make.left.right.equalTo(self)
			make.height.equalTo(head_height)
		}

		header_label.snp.makeConstraints { make in
			make.top.bottom.equalTo(header_view)
			make.left.equalTo(header_view).inset(10)
		}

		inform_button.snp.makeConstraints { make in
			make.top.bottom.equalTo(header_view)
			make.right.equalTo(header_view).inset(10)
		}

		write_button.snp.makeConstraints { make in
			make.top.bottom.equalTo(header_view)
			make.right.equalTo(inform_button.snp.left).inset(-10)
		}

		post_collectionView.snp.makeConstraints { make in
			make.top.equalTo(header_view.snp.bottom)
			make.left.right.bottom.equalTo(self)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
