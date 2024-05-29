//
//  Welcome_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 5/12/24.
//

import UIKit

import RxSwift
import SnapKit 

final class Welcome_viewController: UIViewController {
	
	let welcome_view = Welcome_view()
	let welcome_viewModel = Welcome_viewModel()
	var disposeBag = DisposeBag()
	var button_touch_count = 0
	var email_address = ""

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		// login button binding
		welcome_view.login_button.rx.tap.bind{ [weak self] in
			self!.login_button_tap()
		}.disposed(by: disposeBag)

		// register button binding
		welcome_view.register_button.rx.tap.bind{ [weak self] in
			self!.register_button_tap()
		}.disposed(by: disposeBag)

		// google login button binding - login view's button
		welcome_view.login_view.google_login_button.rx.tap.bind { [weak self] in
			self!.button_touch_count = 2
			self!.welcome_viewModel.google_login(vc: self!) { isSuccess in
				if isSuccess
				{
					// Check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self!.name_check()
				}
			}
		}.disposed(by: disposeBag)

		// google login button binding - register view's button
		welcome_view.register_view.google_login_button.rx.tap.bind { [weak self] in
			self!.button_touch_count = 2
			self!.welcome_viewModel.google_login(vc: self!) { isSuccess in
				if isSuccess
				{
					// check to server, user have name
					// If server don't have name, show name view
					// If server have name, move to main view
					self!.name_check()
				}
			}
		}.disposed(by: disposeBag)

		view.addSubview(welcome_view)
		welcome_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(view)
		}
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
				show_alert(
					viewController: self,
					title: "실패",
					message: "허용되지 않은 특수문자가 이메일에 들어가있습니다.",
					button_title: "확인",
					handler: nil)

				return
			}
			else if welcome_view.get_password().hasSpecial_characters()
			{
				show_alert(
					viewController: self,
					title: "실패",
					message: "허용되지 않은 특수문자가 비밀번호에 들어가있습니다.",
					button_title: "확인",
					handler: nil)

				return
			}
			// Login
			welcome_viewModel.login(
				email: welcome_view.get_email(), password: welcome_view.get_password()) { [weak self] isSuccess in
					if isSuccess
					{
						self!.name_check()
					}
					else
					{
						show_alert(
							viewController: self,
							title: "로그인",
							message: "로그인에 실패하였습니다.\n아이디와 비밀번호를 다시 확인해주세요.",
							button_title: "확인",
							handler: nil)
					}
				}
		}
		else if button_touch_count == 2 // At name view, button touch
		{
			// Exception
			if welcome_view.name_view.name_textField.text?.count ?? 0 > 10
			{
				show_alert(viewController: self,
						   title: "실패",
						   message: "닉네은 10글자 이하 입니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}
			else if (welcome_view.name_view.name_textField.text ?? "").hasSpecial_characters()
			{
				show_alert(viewController: self,
						   title: "실패",
						   message: "허용되지않은 특수문자가 포함되어 있습니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}

			// Register name to mullo server
			welcome_viewModel.register_name(
				name: welcome_view.name_view.name_textField.text ?? "", email: email_address) { [weak self] result in
				if result == "success"
				{
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					// Change VC ( current VC -> Main VC )
					self?.change_to_mainView()
				}
				else if result == "overlap_name"
				{
					show_alert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
				}
				else if result == "overlap_email"
				{
					show_alert(viewController: self, title: "알림", message: "이미 가입한 계정입니다.", button_title: "확인", handler: {action in self?.change_to_mainView()})
					self!.welcome_viewModel.get_name(email: self!.email_address) { name in
						UserDefaults.standard.setValue(name, forKey: "name")
					}
				}
				else
				{
					print("error")
					print(result)
				}

			}
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
				welcome_viewModel.register(
					email: welcome_view.get_email(), password: welcome_view.get_password()) { [weak self] isSuccess in
					if isSuccess
					{
						self?.button_touch_count = 2
						self?.email_address = self!.welcome_view.get_email()
						// Change view ( current view -> name_view )
						self!.change_to_nameView()
					}
					else
					{
						show_alert(viewController: self,
								   title: "알림",
								   message: "회원 가입에 실패하였습니다.\n 정보를 다시 확인하여 주세요.",
								   button_title: "확인",
								   handler: nil)
					}
				}
			}
		}
		else if button_touch_count == 2 // At name view, button touch
		{
			// Exception
			if welcome_view.name_view.name_textField.text?.count ?? 0 > 10
			{
				show_alert(viewController: self,
						   title: "실패",
						   message: "닉네은 10글자 이하 입니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}
			else if (welcome_view.name_view.name_textField.text ?? "").hasSpecial_characters()
			{
				show_alert(viewController: self,
						   title: "실패",
						   message: "허용되지않은 특수문자가 포함되어 있습니다.",
						   button_title: "확인",
						   handler: nil)

				return
			}

			// Register name to mullo server
			welcome_viewModel.register_name(
				name: welcome_view.name_view.name_textField.text ?? "",email: email_address) { [weak self] result in
				if result == "success"
				{
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					// Change VC ( current VC -> Main VC )
					self?.change_to_mainView()
				}
				else if result == "overlap_name"
				{
					show_alert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: nil)
				}
				else if result == "overlap_email"
				{
					show_alert(viewController: self, title: "알림", message: "이미 가입된 계정입니다.", button_title: "확인", handler: nil)
					self!.welcome_viewModel.get_name(email: self!.email_address) { name in
						UserDefaults.standard.setValue(name, forKey: "name")
						self!.change_to_mainView()
					}
				}
				else
				{
					print("error")
					print(result)
				}
			}
		}
	} 

	final func register_exec() -> Bool
	{
		if welcome_view.register_view.email_textField.text == ""
		{
			show_alert(
				viewController: self, title: "실패", message: "이메일을 입력해주세요", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.password_textField.text == ""
		{
			show_alert(
				viewController: self, title: "실패", message: "비밀 번호를 입력해주세요", button_title: "확인", handler: nil)

			return false
		}
		else if (welcome_view.register_view.password_textField.text ?? "").count < 8
		{
			show_alert(
				viewController: self, title: "실패", message: "비밀 번호는 8자 이상입니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.password_confirm_textField.text != welcome_view.register_view.password_textField.text
		{
			show_alert(
				viewController: self, title: "실패", message: "비밀 번호를 다시 확인하여 주세요.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.register_view.email_textField.text?.count ?? 0 > 320
		{
			show_alert(
				viewController: self, title: "실패", message: "너무 긴 이메일 입니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.get_email().hasSpecial_characters()
		{
			show_alert(
				viewController: self, title: "실패", message: "허용되지 않은 특수문자가 이메일에 들어가있습니다.", button_title: "확인", handler: nil)

			return false
		}
		else if welcome_view.get_password().hasSpecial_characters()
		{
			show_alert(
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
		// Checking user have name
		welcome_viewModel.get_name(email: email_address) { [weak self] name in

			if name == "|none" // Case : User did register but didn't set name
			{
				self!.button_touch_count = 2
				self!.email_address = self!.welcome_view.get_email()
				// Change view ( current view -> name view )
				self!.change_to_nameView()
			}
			else if name == "|error" // Case : error
			{
				show_alert(
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
		}
	}
}
