//
//  Setting_view.swift
//  Mullo
//
//  Created by seongjun cho on 8/10/24.
//

import UIKit
import SnapKit

class Setting_view: UIView {

	var back_button: UIButton = {
		let back_button = UIButton()

		back_button.setImage(
			UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)),
			for: .normal)
		back_button.tintColor = UIColor(named: "REVERSE_SYS")
		back_button.contentMode = .scaleAspectFit
		
		return back_button
	}()

	var setting_label: UILabel = {
		let setting_label = UILabel()

		setting_label.text = "설정"
		setting_label.tintColor = UIColor(named: "REVERSE_SYS")
		setting_label.font = UIFont(name: "Urbanist-Bold", size: 20)

		return setting_label
	}()

	var border_view: UIView = {
		let border_view = UIView()

		border_view.backgroundColor = UIColor.gray

		return border_view
	}()

	var question_button: UIButton = {
		let question_button = UIButton()

		question_button.layer.borderColor = UIColor(named: "REVERSE_SYS")!.cgColor
		question_button.layer.borderWidth = 1.0
		question_button.setTitle("건의하기", for: .normal)
		question_button.titleLabel?.font = UIFont(name: "Urbanist-SemiBold", size: 20)
		question_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		question_button.layer.cornerRadius = 5.0

		return question_button
	}()

	var right_button: UIButton = {
		let right_button = UIButton()

		right_button.layer.borderColor = UIColor(named: "REVERSE_SYS")!.cgColor
		right_button.layer.borderWidth = 1.0
		right_button.setTitle("권리표기", for: .normal)
		right_button.titleLabel?.font = UIFont(name: "Urbanist-SemiBold", size: 20)
		right_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		right_button.layer.cornerRadius = 5.0

		return right_button
	}()

	var logout_button: UIButton = {
		let logout_button = UIButton()

		logout_button.layer.borderColor = UIColor.red.cgColor
		logout_button.layer.borderWidth = 1.0
		logout_button.setTitle("로그아웃", for: .normal)
		logout_button.titleLabel?.font = UIFont(name: "Urbanist-SemiBold", size: 20)
		logout_button.setTitleColor(.red, for: .normal)
		logout_button.layer.cornerRadius = 5.0

		return logout_button
	}()

	var deleteID_button: UIButton = {
		let deleteID_button = UIButton()

		deleteID_button.layer.borderColor = UIColor.red.cgColor
		deleteID_button.layer.borderWidth = 1.0
		deleteID_button.setTitle("탈퇴하기", for: .normal)
		deleteID_button.titleLabel?.font = UIFont(name: "Urbanist-SemiBold", size: 20)
		deleteID_button.setTitleColor(.red, for: .normal)
		deleteID_button.layer.cornerRadius = 5.0

		return deleteID_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor(named: "NATURAL")

		addSubview(back_button)
		addSubview(setting_label)
		addSubview(border_view)
		addSubview(question_button)
		addSubview(right_button)
		addSubview(logout_button)
		addSubview(deleteID_button)

		back_button.snp.makeConstraints { make in
			make.top.equalTo(self).inset(top_inset)
			make.left.equalTo(self).inset(10)
			make.height.equalTo(30)
			make.width.equalTo(60)
		}

		setting_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(top_inset)
			make.left.equalTo(back_button.snp.right).inset(-10)
			make.right.equalTo(self)
			make.height.equalTo(30)
		}

		border_view.snp.makeConstraints { make in
			make.top.equalTo(back_button.snp.bottom).inset(-10)
			make.left.right.equalTo(self)
			make.height.equalTo(1)
		}

		question_button.snp.makeConstraints { make in
			make.top.equalTo(border_view.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(60)
		}

		right_button.snp.makeConstraints { make in
			make.top.equalTo(question_button.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(60)
		}

		logout_button.snp.makeConstraints { make in
			make.top.equalTo(right_button.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(60)
		}

		deleteID_button.snp.makeConstraints { make in
			make.top.equalTo(logout_button.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(60)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
