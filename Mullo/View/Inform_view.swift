//
//  Inform_view.swift
//  Mullo
//
//  Created by seongjun cho on 8/6/24.
//

import UIKit

final class Inform_view: UIView {

	var back_button: UIButton = {
		let back_button = UIButton()

		back_button.setImage(UIImage(systemName: "arrow.backward")?.resized(to: CGSize(width: 40, height: 30)), for: .normal)
		back_button.tintColor = UIColor(named: "REVERSE_SYS")
		
		return back_button
	}()

	var setting_button: UIButton = {
		let setting_button = UIButton()

		setting_button.setImage(UIImage(systemName: "gearshape")?.resized(to: CGSize(width: 30, height: 30)), for: .normal)
		setting_button.tintColor = UIColor(named: "REVERSE_SYS")

		return setting_button
	}()

	private let inform_label: UILabel = {
		let inform_label = UILabel()

		inform_label.text = "나의 정보"
		inform_label.font = UIFont(name: "Urbanist-Bold", size: 30)
		inform_label.tintColor = UIColor(named: "REVERSE_SYS")

		return inform_label
	}()

	var name_label: UILabel = {
		let name_label = UILabel()

		name_label.font = UIFont(name: "Urbanist-Bold", size: 20)
		name_label.tintColor = UIColor(named: "REVERSE_SYS")

		return name_label
	}()

	var name_change_button: UIButton = {
		let name_change_button = UIButton()

		name_change_button.setTitle("닉네임 변경", for: .normal)
		name_change_button.titleLabel?.textColor = UIColor.black
		name_change_button.backgroundColor = UIColor.lightGray
		name_change_button.layer.cornerRadius = 5.0
		name_change_button.clipsToBounds = true

		return name_change_button
	}()

	private let border_view: UIView = {
		let border_view = UIView()

		border_view.backgroundColor = UIColor.gray

		return border_view
	}()

	private let myPost_label: UILabel = {
		let myPost_label = UILabel()

		myPost_label.text = "작성글 목록"
		myPost_label.font = UIFont(name: "Urbanist-Bold", size: 30)
		myPost_label.tintColor = UIColor(named: "REVERSE_SYS")

		return myPost_label
	}()

	var myPost_collectionView: UICollectionView = {
		let myPost_collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

		myPost_collectionView.backgroundColor = UIColor(named: "NATURAL")
		myPost_collectionView.register(
			MyPost_collectionView_cell.self, forCellWithReuseIdentifier: MyPost_collectionView_cell.identifier)

		return myPost_collectionView
	}()

	var color_view: UIView = {
		let color_view = UIView()

		color_view.isUserInteractionEnabled = false

		return color_view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor(named: "NATURAL")
		
		addSubview(back_button)
		addSubview(setting_button)
		addSubview(inform_label)
		addSubview(name_label)
		addSubview(name_change_button)
		addSubview(border_view)
		addSubview(myPost_label)
		addSubview(myPost_collectionView)
		addSubview(color_view)

		back_button.snp.makeConstraints { make in
			make.top.equalTo(self).inset(top_inset)
			make.left.equalTo(self).inset(10)
			make.height.equalTo(30)
			make.width.equalTo(60)
		}

		setting_button.snp.makeConstraints { make in
			make.top.equalTo(back_button.snp.bottom).inset(-20)
			make.right.equalTo(self).inset(10)
			make.width.height.equalTo(30)
		}

		inform_label.snp.makeConstraints { make in
			make.top.equalTo(back_button.snp.bottom).inset(-20)
			make.left.equalTo(self).inset(10)
			make.right.equalTo(setting_button.snp.left)
			make.height.equalTo(25)
		}

		name_label.snp.makeConstraints { make in
			make.top.equalTo(inform_label.snp.bottom).inset(-30)
			make.left.right.equalTo(self).inset(10)
			make.height.equalTo(25)
		}

		name_change_button.snp.makeConstraints { make in
			make.top.equalTo(name_label.snp.bottom).inset(-10)
			make.left.right.equalTo(self).inset(10)
			make.height.equalTo(30)
		}

		border_view.snp.makeConstraints { make in
			make.top.equalTo(name_change_button.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(1)
		}

		myPost_label.snp.makeConstraints { make in
			make.top.equalTo(border_view.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(10)
			make.height.equalTo(30)
		}

		myPost_collectionView.snp.makeConstraints { make in
			make.top.equalTo(myPost_label.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(self)
		}

		color_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(self)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
