//
//  Name_view.swift
//  Mullo
//
//  Created by seongjun cho on 8/21/24.
//

import UIKit
import SnapKit

class Name_view: UIView {

	var name_textField: UITextField = {
		let name_textField = UITextField()

		name_textField.placeholder = "닉네임을 입력해주세요."
		name_textField.setPlaceholderColor(UIColor.darkGray)
		name_textField.addLeftPadding()
		name_textField.backgroundColor = UIColor(cgColor:
													CGColor(red: 247 / 255,
															green: 248 / 255,
															blue: 249 / 255,
															alpha: 1.0))
		name_textField.layer.borderWidth = 1.0
		name_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		name_textField.layer.cornerRadius = 8
		name_textField.clipsToBounds = true
		name_textField.textColor = UIColor.black
		name_textField.autocorrectionType = .no
		name_textField.spellCheckingType = .no

		return name_textField
	}()

	var name_inform_label: UILabel = {
		let name_inform_label = UILabel()

		name_inform_label.text = "10자 이내, 특수문자 금지"
		name_inform_label.textColor = UIColor.darkGray
		name_inform_label.font = UIFont(name: "Urbanist-Bold", size: 15)
		name_inform_label.textAlignment = .right

		return name_inform_label
	}()

	var eula_label: UILabel = {
		let eula_label = UILabel()

		eula_label.text = "회원가입시, 서비스이용 약관과 최종 사용자 사용권 계약에 동의합니다."
		eula_label.font = UIFont(name: "Urbanist-SemiBold", size: 12)
		eula_label.textColor = UIColor(named: "REVERSE_SYS")
		eula_label.textAlignment = .right

		return eula_label
	}()

	var eula_button: UIButton = {
		let eula_button = UIButton()

		eula_button.setTitle("자세히 보기", for: .normal)
		eula_button.titleLabel?.font = UIFont(name: "Urbanist-SemiBold", size: 15)
		eula_button.setTitleColor(UIColor.gray, for: .normal)

		return eula_button
	}()


	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(name_textField)
		addSubview(name_inform_label)
		addSubview(eula_label)
		addSubview(eula_button)

		name_textField.snp.makeConstraints { make in
			make.top.equalTo(self)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		name_inform_label.snp.makeConstraints { make in
			make.top.equalTo(name_textField.snp.bottom).inset(-15)
			make.right.equalTo(name_textField)
			make.height.equalTo(15)
			make.width.equalTo(200)
		}

		eula_label.snp.makeConstraints { make in
			make.top.equalTo(name_inform_label.snp.bottom).inset(-10)
			make.right.equalTo(name_textField)
			make.left.equalTo(self)
			make.height.equalTo(15)
		}

		eula_button.snp.makeConstraints { make in
			make.top.equalTo(eula_label.snp.bottom).inset(-10)
			make.width.equalTo(eula_button.sizeThatFits(CGSize(width: screen_width, height: 15)))
			make.right.equalTo(name_textField)
			make.height.equalTo(15)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
