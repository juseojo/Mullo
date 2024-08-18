//
//  Welcome_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 5/12/24.
//

import UIKit

import RxSwift
import SnapKit 
import AuthenticationServices

final class Welcome_viewController: UIViewController {
	
	let welcome_view = Welcome_view()
	let welcome_viewModel = Welcome_viewModel()
	var disposeBag = DisposeBag()
	var button_touch_count = 0
	var apple_login_identifier : String?
	var email_address = ""

	override func viewDidLoad() {
		super.viewDidLoad()

		// basic setting
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")
		
		// delegate
		welcome_view.name_view.name_textField.delegate = self
		welcome_view.register_view.email_textField.delegate = self
		welcome_view.register_view.password_textField.delegate = self
		welcome_view.register_view.password_confirm_textField.delegate = self
		welcome_view.login_view.email_textField.delegate = self
		welcome_view.login_view.password_textField.delegate = self

		// server check
		isServer_ok(vc: self)

		// binding
		rx_binding()

		// basic layout
		view.addSubview(welcome_view)
		welcome_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(view)
		}
	}

	final func rx_binding()
	{
		// login button binding
		welcome_view.login_button.rx.tap
			.bind{ [weak self] in self?.login_button_tap() }
			.disposed(by: disposeBag)

		// register button binding
		welcome_view.register_button.rx.tap
			.bind{ [weak self] in self?.register_button_tap() }
			.disposed(by: disposeBag)

		// find_password button binding
		welcome_view.login_view.find_password_button.rx.tap
			.bind { [weak self] in self!.welcome_viewModel.find_password(email: self!.welcome_view.get_email()) }
			.disposed(by: disposeBag)

		//google login button binding - login view's button
		welcome_view.login_view.google_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
			self?.welcome_viewModel.google_login(vc: self!).subscribe(onNext: { [weak self] mail in
				if mail != "" {
					// Check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self?.email_address = mail
					self?.name_check()
				}
			}).disposed(by: self!.disposeBag)
		}.disposed(by: disposeBag)

		// google login button binding - register view's button
		welcome_view.register_view.google_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
			self?.welcome_viewModel.google_login(vc: self!).subscribe(onNext: { [weak self] mail in
				if mail != "" {
					// Check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self?.email_address = mail
					self?.name_check()
				}
			}).disposed(by: self!.disposeBag)
		}.disposed(by: disposeBag)

		//kakao login button binding - login view's button
		welcome_view.login_view.kakao_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
			self?.welcome_viewModel.kakao_login().subscribe(onNext: { [weak self] mail in
				if mail != "" {
					// Check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self?.email_address = mail
					self?.name_check()
				}
			}).disposed(by: self!.disposeBag)
		}.disposed(by: disposeBag)

		//kakao login button binding - register view's button
		welcome_view.register_view.kakao_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
			self?.welcome_viewModel.kakao_login().subscribe(onNext: { [weak self] mail in
				if mail != "" {
					// Check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self?.email_address = mail
					self?.name_check()
				}
			}).disposed(by: self!.disposeBag)
		}.disposed(by: disposeBag)

		//apple login button binding - register view's button
		welcome_view.register_view.apple_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
				self?.welcome_viewModel.apple_login(vc: self!)
		}.disposed(by: disposeBag)

		//apple login button binding - login view's button
		welcome_view.login_view.apple_login_button.rx.tap
			.bind { [weak self] in
			self?.button_touch_count = 2
				self?.welcome_viewModel.apple_login(vc: self!)
		}.disposed(by: disposeBag)
	}

	final func login_button_tap()
	{
		if button_touch_count == 0
		{
			button_touch_count = 1
			// Change view ( current view -> login_view )
			self.change_to_loginView()
		}
		else if button_touch_count == 1 // At login view, button touch
		{
			// Exception
			if welcome_view.get_email().hasSpecial_characters()
			{
				AlertHelper.showAlert(
					viewController: self,
					title: "실패",
					message: "허용되지 않은 특수문자가 이메일에 들어가있습니다.",
					button_title: "확인",
					handler: nil)

				return
			}
			else if welcome_view.get_password().hasSpecial_characters()
			{
				AlertHelper.showAlert(
					viewController: self,
					title: "실패",
					message: "허용되지 않은 특수문자가 비밀번호에 들어가있습니다.",
					button_title: "확인",
					handler: nil)

				return
			}
			// Login
			welcome_viewModel.login(email: welcome_view.get_email(), password: welcome_view.get_password())
				.subscribe(onNext: { [weak self] isSuccess in

				if isSuccess
				{
					self!.email_address = self!.welcome_view.get_email()
					self!.name_check()
				}
				else
				{
					AlertHelper.showAlert(
						viewController: self,
						title: "로그인",
						message: "로그인에 실패하였습니다.\n아이디와 비밀번호를 다시 확인해주세요.",
						button_title: "확인",
						handler: nil)
				}
			}).disposed(by: disposeBag)
		}
		else if button_touch_count == 2 // At name view, button touch ( Case : user try social login, but didn't regist )
		{
			// Exception
			if welcome_view.name_view.name_textField.text?.count ?? 0 > 10
			{
				AlertHelper.showAlert(viewController: self,
						   title: "실패",
						   message: "닉네은 10글자 이하 입니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}
			else if (welcome_view.name_view.name_textField.text ?? "").hasSpecial_characters()
			{
				AlertHelper.showAlert(viewController: self,
						   title: "실패",
						   message: "허용되지않은 특수문자가 포함되어 있습니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}

			// Case : Apple login
			if apple_login_identifier != nil
			{
				welcome_viewModel.change_name(
					name: welcome_view.name_view.name_textField.text ?? "", identifier: apple_login_identifier!) { result in
						if result == "success" {
							print("name change success")
							UserDefaults.standard.setValue(self.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
							// Change VC ( current VC -> Main VC )
							self.change_to_mainView()
						}
						else if result == "overlap_name" {
							AlertHelper.showAlert(
								viewController: self, title: "실패", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
							self.welcome_view.name_view.name_textField.text = ""
						}
						else {
							AlertHelper.showAlert(
								viewController: self, title: "오류", message: "서버 오류입니다.", button_title: "확인", handler: nil)
							self.welcome_view.name_view.name_textField.text = ""
						}
					}

				return
			}

			// Register name to mullo server
			welcome_viewModel.register_name(name: welcome_view.name_view.name_textField.text ?? "", email: email_address, identifier: "", auth_code: "")
				.subscribe(onNext: { [weak self] result in
				if result == "success"
				{
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					print("finaly login success")
					// Change VC ( current VC -> Main VC )
					self!.change_to_mainView()
				}
				else if result == "overlap_name"
				{
					AlertHelper.showAlert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
				}
				else if result == "overlap_email"
				{
					AlertHelper.showAlert(viewController: self, title: "알림", message: "이미 가입한 계정입니다.", button_title: "확인", handler: { action in self!.change_to_mainView()})
					self!.welcome_viewModel.get_name(email: self!.email_address).subscribe(onNext: { name in

						UserDefaults.standard.setValue(name, forKey: "name")
					}).disposed(by: self!.disposeBag)
				}
				else
				{
					print("error")
					AlertHelper.showAlert(
						title: "오류", message: "가입 에러입니다. 계속 문제시 다른 방법을 이용해주세요..", button_title: "확인", handler: nil)
					print(result)
				}
			}).disposed(by: disposeBag)
		}
	}

	final func register_button_tap()
	{
		if button_touch_count == 0
		{
			button_touch_count = 1
			// Change view ( current view -> register_view )
			self.change_to_registerView()
		}
		else if button_touch_count == 1 // At register view, button touch
		{
			if register_exec()
			{
				welcome_viewModel.register(email: welcome_view.get_email(), password: welcome_view.get_password())
					.subscribe(onNext: { [weak self] isSuccess in

					if isSuccess
					{
						self!.button_touch_count = 2
						self!.email_address = self!.welcome_view.get_email()
						// Change view ( current view -> name_view )
						self!.change_to_nameView()
					}
					else
					{
						AlertHelper.showAlert(viewController: self,
								   title: "알림",
								   message: "회원 가입에 실패하였습니다.\n 정보를 다시 확인하여 주세요.",
								   button_title: "확인",
								   handler: nil)
					}
					}).disposed(by: disposeBag)
			}
		}
		else if button_touch_count == 2 // At name view, button touch
		{
			// Exception
			if welcome_view.name_view.name_textField.text?.count ?? 0 > 10
			{
				AlertHelper.showAlert(viewController: self,
						   title: "실패",
						   message: "닉네은 10글자 이하 입니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}
			else if (welcome_view.name_view.name_textField.text ?? "").hasSpecial_characters()
			{
				AlertHelper.showAlert(viewController: self,
						   title: "실패",
						   message: "허용되지않은 특수문자가 포함되어 있습니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}

			if apple_login_identifier != nil
			{
				welcome_viewModel.change_name(
					name: welcome_view.name_view.name_textField.text ?? "", identifier: apple_login_identifier!) { result in
						if result == "success" {
							print("name change success")
							UserDefaults.standard.setValue(self.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
							// Change VC ( current VC -> Main VC )
							self.change_to_mainView()
						}
						else if result == "overlap_name" {
							AlertHelper.showAlert(
								viewController: self, title: "실패", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
							self.welcome_view.name_view.name_textField.text = ""
						}
						else {
							AlertHelper.showAlert(
								viewController: self, title: "오류", message: "서버 오류입니다.", button_title: "확인", handler: nil)
							self.welcome_view.name_view.name_textField.text = ""
						}
					}
				
				return
			}

			// Register name to mullo server
			welcome_viewModel.register_name(name: welcome_view.name_view.name_textField.text ?? "", email: email_address, identifier: "", auth_code: "")
				.subscribe(onNext: { [weak self] result in

				if result == "success"
				{
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					// Change VC ( current VC -> Main VC )
					self!.change_to_mainView()
				}
				else if result == "overlap_name"
				{
					AlertHelper.showAlert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
				}
				else if result == "overlap_email"
				{
					AlertHelper.showAlert(viewController: self, title: "알림", message: "이미 가입된 계정입니다.", button_title: "확인", handler: nil)
					self!.welcome_viewModel.get_name(email: self!.email_address) .subscribe(onNext: { name in

						UserDefaults.standard.setValue(name, forKey: "name")
					}).disposed(by: self!.disposeBag)
				}
				else
				{
					print("error")
					print(result)
				}
				}).disposed(by: disposeBag)
		}
	} 

	final func register_exec() -> Bool
	{
		if welcome_view.register_view.email_textField.text == ""
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "이메일을 입력해주세요", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.password_textField.text == ""
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "비밀 번호를 입력해주세요", button_title: "확인", handler: nil)

			return false
		}
		else if (welcome_view.register_view.password_textField.text ?? "").count < 8
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "비밀 번호는 8자 이상입니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.password_confirm_textField.text != welcome_view.register_view.password_textField.text
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "비밀 번호를 다시 확인하여 주세요.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.email_textField.text?.count ?? 0 > 320
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "너무 긴 이메일 입니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.get_email().hasSpecial_characters()
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "허용되지 않은 특수문자가 이메일에 들어가있습니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.get_password().hasSpecial_characters()
		{
			AlertHelper.showAlert(
				viewController: self, title: "실패", message: "허용되지 않은 특수문자가 비밀 번호에 들어가있습니다.", button_title: "확인", handler: nil)

			return false
		}

		return true
	}

	final func change_to_nameView()
	{
		DispatchQueue.main.async {
			self.welcome_view.register_view.removeFromSuperview()
			self.welcome_view.login_view.removeFromSuperview()

			self.welcome_view.addSubview(self.welcome_view.name_view)
			self.welcome_view.name_view.alpha = 1.0

			self.welcome_view.name_view.snp.makeConstraints { make in
				make.top.equalTo(self.welcome_view.welcome_label.snp.bottom).offset(50)
				make.height.equalTo(85)
				make.left.right.equalTo(self.welcome_view)
			}

			if self.welcome_view.register_button.superview != nil
			{
				self.welcome_view.register_button.snp.remakeConstraints { make in
					make.top.equalTo(self.welcome_view.name_view.snp.bottom).offset(15)
					make.left.right.equalTo(self.welcome_view).inset(30)
					make.height.equalTo(55)
				}
			}
			else
			{
				self.welcome_view.login_button.snp.remakeConstraints { make in
					make.top.equalTo(self.welcome_view.name_view.snp.bottom).offset(15)
					make.left.right.equalTo(self.welcome_view).inset(30)
					make.height.equalTo(55)
				}
			}
		}
	}

	final func change_to_registerView()
	{
		DispatchQueue.main.async {
			self.welcome_view.login_button.removeFromSuperview()
			self.welcome_view.login_view.removeFromSuperview()

			self.welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(self.welcome_view.header_view.snp.bottom).offset(screen_height / 10)
			}

			self.welcome_view.register_button.snp.remakeConstraints { make in
				make.top.equalTo(self.welcome_view.register_view.snp.bottom)
				make.left.right.equalTo(self.welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.register_view.alpha = 1.0
			}
		}
	}

	final func change_to_loginView()
	{
		DispatchQueue.main.async {
			self.welcome_view.register_button.removeFromSuperview()
			self.welcome_view.register_view.removeFromSuperview()

			self.welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(self.welcome_view.header_view.snp.bottom).offset(screen_height / 6)
			}

			self.welcome_view.login_button.snp.remakeConstraints { make in
				make.top.equalTo(self.welcome_view.login_view.snp.bottom)
				make.left.right.equalTo(self.welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.login_view.alpha = 1.0
			}
		}
	}

	final func change_to_mainView()
	{
		DispatchQueue.main.async {
			let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
			guard let delegate = sceneDelegate else {
				print("sceneDelegate delegate error")
				return
			}
			delegate.changeRootVC(Main_ViewController(), animated: true)
		}
	}

	final func name_check()
	{
		// Exception
		if email_address == ""
		{
			AlertHelper.showAlert(
				viewController: self,
				title: "오류",
				message: "로그인에 실패하였습니다.\n다시 시도해주세요.",
				button_title: "확인",
				handler: nil)

			return
		}

		// Checking user have name
		welcome_viewModel.get_name(email: email_address).subscribe(onNext: { [weak self] name in

			if name == "|none" // Case : User did register but didn't set name
			{
				self!.button_touch_count = 2
				// Change view ( current view -> name view )
				self!.change_to_nameView()
			}
			else if name == "|error" // Case : error
			{
				AlertHelper.showAlert(
					viewController: self,
					title: "오류",
					message: "로그인에 실패하였습니다.\n다시 시도해주세요.",
					button_title: "확인",
					handler: nil)
			}
			else // Case : Login Success
			{
				print(name)
				print("login success")
				UserDefaults.standard.set(name, forKey: "name")
				// Change VC ( current VC -> Main VC )
				self!.change_to_mainView()
			}
		}).disposed(by: disposeBag)
	}
}

extension Welcome_viewController: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
			print("apple login success")

			// Case : Not first apple login
			if credential.email == nil
			{
				apple_login_identifier = credential.user

				welcome_viewModel.hasName(identifier: credential.user)
					.subscribe(onNext: { [weak self] hasName in
						if hasName == "false"
						{
							self!.button_touch_count = 2
							// Change VC ( current VC -> name VC )
							self!.change_to_nameView()
						}
						else if hasName == "null"
						{
							self!.welcome_viewModel.register_name(
								name: "none+",
								email: "",
								identifier: credential.user,
								auth_code: String(data: credential.authorizationCode!, encoding: .utf8)!)
								.subscribe(onNext: { [weak self] result in
									if result == "success"
									{
										self!.button_touch_count = 2
										// Change VC ( current VC -> name VC )
										self!.change_to_nameView()
									}
									else
									{
										print("error")
										print(result)
									}
								}).disposed(by: self!.disposeBag)
						}
						else
						{
							self!.button_touch_count = 2
							UserDefaults.standard.set(hasName, forKey: "name")
							// Change VC ( current VC -> main VC )
							self!.change_to_mainView()
						}
					}).disposed(by: disposeBag)
			}
			else // Case : First apple login
			{
				email_address = credential.email ?? ""
				apple_login_identifier = credential.user

				welcome_viewModel.register_name(
					name: "none+",
					email: email_address,
					identifier: credential.user,
					auth_code: String(data: credential.authorizationCode!, encoding: .utf8)!)
					.subscribe(onNext: { [weak self] result in
						if result == "success"
						{
							self!.button_touch_count = 2
							// Change VC ( current VC -> name VC )
							self!.change_to_nameView()
						}
						else
						{
							print("error")
							print(result)
						}
					}).disposed(by: disposeBag)
			}
		}

		// 실패 후 동작
		func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
			print("apple login error")
			AlertHelper.showAlert(
				viewController: self,
				title: "오류",
				message: "로그인에 실패하였습니다.\n다시 시도해주세요.",
				button_title: "확인",
				handler: nil)
		}
	}
}


extension Welcome_viewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
		 self.view.endEditing(true)
	}
}
