//
//  Welcome_view.swift
//  Mullo
//
//  Created by seongjun cho on 5/12/24.
//

import UIKit

class Welcome_view: UIView {

	var header_view: UIView = {
		let header_view = UIView()

		header_view.backgroundColor = UIColor(named: "NATURAL")

		return header_view
	}()

	var header_label: UILabel = {
		let header_label = UILabel()

		header_label.text = "멀로"
		header_label.tintColor = UIColor(named: "REVERSE_SYS")
		header_label.font = UIFont(name: "Urbanist-Bold", size: 30)

		return header_label
	}()

	var welcome_label: UILabel = {
		let welcome_label = UILabel()

		welcome_label.text = "어서오세요.\n고민 투표 앱 멀로입니다."
		welcome_label.tintColor = UIColor(named: "REVERSE_SYS")
		welcome_label.font = UIFont(name: "Urbanist-Bold", size: 30)
		welcome_label.numberOfLines = 2

		return welcome_label
	}()

	var login_button: UIButton = {
		let login_button = UIButton()

		login_button.backgroundColor = UIColor(named: "REVERSE_SYS")
		login_button.setTitleColor(UIColor(named: "NATURAL"), for: .normal)
		login_button.setTitle("로그인", for: .normal)
		login_button.titleLabel?.font = UIFont(name: "Urbanist-Bold", size: 15)
		login_button.layer.cornerRadius = 8
		login_button.clipsToBounds = true

		return login_button
	}()

	var register_button: UIButton = {
		let register_button = UIButton()

		register_button.backgroundColor = UIColor(named: "NATURAL")
		register_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		register_button.setTitle("회원가입", for: .normal)
		register_button.titleLabel?.font = UIFont(name: "Urbanist-Bold", size: 15)
		register_button.layer.borderColor = UIColor(named: "REVERSE_SYS")!.cgColor
		register_button.layer.borderWidth = 1.0
		register_button.layer.cornerRadius = 8
		register_button.clipsToBounds = true

		return register_button
	}()

	var login_view: Login_view = {
		let login_view = Login_view()

		login_view.alpha = 0.0

		return login_view
	}()

	var register_view: Register_view = {
		let register_view = Register_view()

		register_view.alpha = 0.0

		return register_view
	}()

	var name_view: Name_view = {
		let name_view = Name_view()

		name_view.alpha = 0.0

		return name_view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		//layout
		addSubview(header_view)
		header_view.addSubview(header_label)
		addSubview(welcome_label)
		addSubview(login_button)
		addSubview(register_button)
		addSubview(login_view)
		addSubview(register_view)

		header_view.snp.makeConstraints { make in
			make.top.equalTo(self).inset(top_inset)
			make.left.right.equalTo(self)
			make.height.equalTo(head_height)
		}

		header_label.snp.makeConstraints { make in
			make.top.bottom.equalTo(header_view)
			make.left.equalTo(header_view).inset(15)
		}

		welcome_label.snp.makeConstraints { make in
			make.top.equalTo(header_view.snp.bottom).offset(screen_height / 4)
			make.left.right.equalTo(self).inset(40)
		}

		login_view.snp.makeConstraints { make in
			make.top.equalTo(welcome_label.snp.bottom).offset(50)
			make.left.right.equalTo(self)
			make.height.equalTo(260)
		}

		register_view.snp.makeConstraints { make in
			make.top.equalTo(welcome_label.snp.bottom).offset(50)
			make.left.right.equalTo(self)
			make.height.equalTo(325)
		}

		login_button.snp.makeConstraints { make in
			make.top.equalTo(welcome_label.snp.bottom).offset(30)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(55)
		}

		register_button.snp.makeConstraints { make in
			make.top.equalTo(login_button.snp.bottom).offset(15)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(55)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	final func get_email() -> String
	{
		if login_view.superview == self
		{
			return login_view.email_textField.text ?? ""
		}

		return register_view.email_textField.text ?? ""
	}

	final func get_password() -> String
	{
		if login_view.superview == self
		{
			return login_view.password_textField.text ?? ""
		}

		return register_view.password_textField.text ?? ""
	}
}

class Login_view: UIView {

	var email_textField: UITextField = {
		let email_textField = UITextField()

		email_textField.placeholder = "이메일을 입력해주세요."
		email_textField.setPlaceholderColor(UIColor.darkGray)
		email_textField.addLeftPadding()
		email_textField.backgroundColor = UIColor(cgColor:
													CGColor(red: 247 / 255,
															green: 248 / 255,
															blue: 249 / 255,
															alpha: 1.0))
		email_textField.layer.borderWidth = 1.0
		email_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		email_textField.layer.cornerRadius = 8
		email_textField.clipsToBounds = true

		return email_textField
	}()

	var password_textField: UITextField = {
		let password_textField = UITextField()

		password_textField.placeholder = "비밀 번호를 입력해주세요."
		password_textField.setPlaceholderColor(UIColor.darkGray)
		password_textField.addLeftPadding()
		password_textField.backgroundColor = UIColor(cgColor:
														CGColor(red: 247 / 255,
																green: 248 / 255,
																blue: 249 / 255,
																alpha: 1.0))
		password_textField.layer.borderWidth = 1.0
		password_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		password_textField.layer.cornerRadius = 8
		password_textField.clipsToBounds = true
		password_textField.isSecureTextEntry = true
		password_textField.textContentType = .password

		return password_textField
	}()

	var find_password_button: UIButton = {
		let find_password_button = UIButton()

		find_password_button.setTitle("비밀번호 찾기", for: .normal)
		find_password_button.setTitleColor(UIColor.darkGray, for: .normal)
		find_password_button.titleLabel?.font = UIFont(name: "Urbanist-Bold", size: 15)

		return find_password_button
	}()

	var social_login_label: UILabel = {
		let social_login_label = UILabel()

		social_login_label.text = "소셜 로그인"
		social_login_label.backgroundColor = UIColor(named: "NATURAL")
		social_login_label.textAlignment = .center

		return social_login_label
	}()

	var line_view: UIView = {
		let line_view = UIView()

		line_view.backgroundColor = UIColor(named: "STROKE")

		return line_view
	}()

	var kakao_login_button: UIButton = {
		let kakao_login_button = UIButton()

		kakao_login_button.setImage(UIImage(named: "Kakao"), for: .normal)
		kakao_login_button.imageView?.contentMode = .scaleAspectFit
		kakao_login_button.layer.borderWidth = 1.0
		kakao_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		kakao_login_button.imageEdgeInsets = .init(top: 7.0, left: 0, bottom: 7.0, right: 0)
		kakao_login_button.layer.cornerRadius = 8.0
		kakao_login_button.clipsToBounds = true

		return kakao_login_button
	}()

	var google_login_button: UIButton = {
		let google_login_button = UIButton()

		google_login_button.setImage(UIImage(named: "Google"), for: .normal)
		google_login_button.imageView?.contentMode = .scaleAspectFit
		google_login_button.layer.borderWidth = 1.0
		google_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		google_login_button.imageEdgeInsets = .init(top: 12.0, left: 0, bottom: 12.0, right: 0)
		google_login_button.layer.cornerRadius = 8.0
		google_login_button.clipsToBounds = true

		return google_login_button
	}()

	var apple_login_button: UIButton = {
		let apple_login_button = UIButton()

		let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)

		apple_login_button.setImage(UIImage(systemName: "apple.logo", withConfiguration: largeConfig), for: .normal)
		apple_login_button.tintColor = UIColor(named: "REVERSE_SYS")
		apple_login_button.imageView?.contentMode = .scaleAspectFit
		apple_login_button.layer.borderWidth = 1.0
		apple_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		apple_login_button.imageEdgeInsets = .init(top: 9.0, left: 0, bottom: 9.0, right: 0)
		apple_login_button.layer.cornerRadius = 8.0
		apple_login_button.clipsToBounds = true

		return apple_login_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(email_textField)
		addSubview(password_textField)
		addSubview(find_password_button)
		addSubview(line_view)
		addSubview(social_login_label)
		addSubview(kakao_login_button)
		addSubview(google_login_button)
		addSubview(apple_login_button)

		self.bringSubviewToFront(social_login_label)
		email_textField.snp.makeConstraints { make in
			make.top.equalTo(self)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		password_textField.snp.makeConstraints { make in
			make.top.equalTo(email_textField.snp.bottom).offset(15)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		find_password_button.snp.makeConstraints { make in
			make.top.equalTo(password_textField.snp.bottom).offset(15)
			make.right.equalTo(password_textField.snp.right)
			make.height.equalTo(15)
		}

		social_login_label.snp.makeConstraints { make in
			make.top.equalTo(find_password_button.snp.bottom).offset(10)
			make.width.equalTo(100)
			make.centerX.equalTo(self.snp.centerX)
			make.height.equalTo(15)
		}

		line_view.snp.makeConstraints { make in
			make.centerY.equalTo(social_login_label)
			make.left.right.equalTo(password_textField)
			make.height.equalTo(1)
		}

		kakao_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.left.equalTo(password_textField.snp.left)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}

		google_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.centerX.equalTo(self.snp.centerX)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}

		apple_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.right.equalTo(password_textField.snp.right)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class Register_view: UIView {

	var email_textField: UITextField = {
		let email_textField = UITextField()

		email_textField.placeholder = "이메일을 입력해주세요."
		email_textField.setPlaceholderColor(UIColor.darkGray)
		email_textField.addLeftPadding()
		email_textField.backgroundColor = UIColor(cgColor:
													CGColor(red: 247 / 255,
															green: 248 / 255,
															blue: 249 / 255,
															alpha: 1.0))
		email_textField.layer.borderWidth = 1.0
		email_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		email_textField.layer.cornerRadius = 8
		email_textField.clipsToBounds = true

		return email_textField
	}()

	var password_textField: UITextField = {
		let password_textField = UITextField()

		password_textField.placeholder = "비밀 번호를 입력해주세요."
		password_textField.setPlaceholderColor(UIColor.darkGray)
		password_textField.addLeftPadding()
		password_textField.backgroundColor = UIColor(cgColor:
														CGColor(red: 247 / 255,
																green: 248 / 255,
																blue: 249 / 255,
																alpha: 1.0))
		password_textField.layer.borderWidth = 1.0
		password_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		password_textField.layer.cornerRadius = 8
		password_textField.clipsToBounds = true
		password_textField.isSecureTextEntry = true
		password_textField.textContentType = .password

		return password_textField
	}()

	var password_confirm_textField: UITextField = {
		let password_confirm_textField = UITextField()

		password_confirm_textField.placeholder = "비밀 번호를 다시 한번 입력해주세요."
		password_confirm_textField.setPlaceholderColor(UIColor.darkGray)
		password_confirm_textField.addLeftPadding()
		password_confirm_textField.backgroundColor = UIColor(cgColor:
														CGColor(red: 247 / 255,
																green: 248 / 255,
																blue: 249 / 255,
																alpha: 1.0))
		password_confirm_textField.layer.borderWidth = 1.0
		password_confirm_textField.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		password_confirm_textField.layer.cornerRadius = 8
		password_confirm_textField.clipsToBounds = true
		password_confirm_textField.isSecureTextEntry = true
		password_confirm_textField.textContentType = .password

		return password_confirm_textField
	}()

	var social_login_label: UILabel = {
		let social_login_label = UILabel()

		social_login_label.text = "소셜 로그인"
		social_login_label.backgroundColor = UIColor(named: "NATURAL")
		social_login_label.textAlignment = .center

		return social_login_label
	}()

	var line_view: UIView = {
		let line_view = UIView()

		line_view.backgroundColor = UIColor(named: "STROKE")

		return line_view
	}()

	var kakao_login_button: UIButton = {
		let kakao_login_button = UIButton()

		kakao_login_button.setImage(UIImage(named: "Kakao"), for: .normal)
		kakao_login_button.imageView?.contentMode = .scaleAspectFit
		kakao_login_button.layer.borderWidth = 1.0
		kakao_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		kakao_login_button.imageEdgeInsets = .init(top: 7.0, left: 0, bottom: 7.0, right: 0)
		kakao_login_button.layer.cornerRadius = 8.0
		kakao_login_button.clipsToBounds = true

		return kakao_login_button
	}()

	var google_login_button: UIButton = {
		let google_login_button = UIButton()

		google_login_button.setImage(UIImage(named: "Google"), for: .normal)
		google_login_button.imageView?.contentMode = .scaleAspectFit
		google_login_button.layer.borderWidth = 1.0
		google_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		google_login_button.imageEdgeInsets = .init(top: 12.0, left: 0, bottom: 12.0, right: 0)
		google_login_button.layer.cornerRadius = 8.0
		google_login_button.clipsToBounds = true

		return google_login_button
	}()

	var apple_login_button: UIButton = {
		let apple_login_button = UIButton()

		let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)

		apple_login_button.setImage(UIImage(systemName: "apple.logo", withConfiguration: largeConfig), for: .normal)
		apple_login_button.tintColor = UIColor(named: "REVERSE_SYS")
		apple_login_button.imageView?.contentMode = .scaleAspectFit
		apple_login_button.layer.borderWidth = 1.0
		apple_login_button.layer.borderColor = UIColor(named: "STROKE")?.cgColor
		apple_login_button.imageEdgeInsets = .init(top: 9.0, left: 0, bottom: 9.0, right: 0)
		apple_login_button.layer.cornerRadius = 8.0
		apple_login_button.clipsToBounds = true

		return apple_login_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(email_textField)
		addSubview(password_textField)
		addSubview(password_confirm_textField)
		addSubview(line_view)
		addSubview(social_login_label)
		addSubview(kakao_login_button)
		addSubview(google_login_button)
		addSubview(apple_login_button)

		self.bringSubviewToFront(social_login_label)

		email_textField.snp.makeConstraints { make in
			make.top.equalTo(self).offset(15)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		password_textField.snp.makeConstraints { make in
			make.top.equalTo(email_textField.snp.bottom).offset(15)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		password_confirm_textField.snp.makeConstraints { make in
			make.top.equalTo(password_textField.snp.bottom).offset(15)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		social_login_label.snp.makeConstraints { make in
			make.top.equalTo(password_confirm_textField.snp.bottom).offset(15)
			make.width.equalTo(100)
			make.centerX.equalTo(self.snp.centerX)
			make.height.equalTo(15)
		}

		line_view.snp.makeConstraints { make in
			make.centerY.equalTo(social_login_label)
			make.left.right.equalTo(password_textField)
			make.height.equalTo(1)
		}

		kakao_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.left.equalTo(password_textField.snp.left)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}

		google_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.centerX.equalTo(self.snp.centerX)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}

		apple_login_button.snp.makeConstraints { make in
			make.top.equalTo(social_login_label.snp.bottom).offset(15)
			make.right.equalTo(password_textField.snp.right)
			make.width.equalTo(100)
			make.height.equalTo(50)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

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

		return name_textField
	}()

	var name_inform_label: UILabel = {
		let name_inform_label = UILabel()

		name_inform_label.text = "10자 이내, 특수문자 금지"
		name_inform_label.textColor = UIColor.darkGray
		name_inform_label.font = UIFont(name: "Urbanist-Bold", size: 15)

		return name_inform_label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(name_textField)
		addSubview(name_inform_label)

		name_textField.snp.makeConstraints { make in
			make.top.equalTo(self)
			make.left.right.equalTo(self).inset(30)
			make.height.equalTo(50)
		}

		name_inform_label.snp.makeConstraints { make in
			make.top.equalTo(name_textField.snp.bottom).offset(15)
			make.right.equalTo(name_textField)
			make.height.equalTo(15)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

