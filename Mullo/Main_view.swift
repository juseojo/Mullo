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
		header_label.font = UIFont(name: "San Francisco", size: 30)

		return header_label
	}()

	private var write_button: UIButton = {
		let write_button = UIButton()

		write_button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
		write_button.tintColor = UIColor.black

		return write_button
	}()

	private var inform_button: UIButton = {
		let inform_button = UIButton()

		inform_button.setImage(UIImage(systemName: "person"), for: .normal)
		inform_button.tintColor = UIColor.black

		return inform_button
	}()

	var post_collection_view: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 0
		layout.scrollDirection = .vertical
		layout.sectionInset = .zero

		let post_collection_view = UICollectionView(frame: .zero, collectionViewLayout: layout)

		post_collection_view.backgroundColor = UIColor(named: "NATURAL")
		post_collection_view.register(
			Post_collection_view_cell.self, forCellWithReuseIdentifier: Post_collection_view_cell.identifier)

		return post_collection_view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		//layout
		addSubview(header_view)
		header_view.addSubview(header_label)
		header_view.addSubview(write_button)
		header_view.addSubview(inform_button)
		addSubview(post_collection_view)

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
			make.width.equalTo(head_height)
		}

		write_button.snp.makeConstraints { make in
			make.top.bottom.equalTo(header_view)
			make.right.equalTo(inform_button.snp.left).inset(10)
			make.width.equalTo(head_height)
		}

		post_collection_view.snp.makeConstraints { make in
			make.top.equalTo(header_view.snp.bottom)
			make.left.right.bottom.equalTo(self)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
