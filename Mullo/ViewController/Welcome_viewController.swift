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

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		welcome_view.login_button.rx.tap.bind{ [weak self] in
			self!.login_button_tap()
		}.disposed(by: disposeBag)

		welcome_view.register_button.rx.tap.bind{ [weak self] in
			self!.register_button_tap()
		}.disposed(by: disposeBag)

		welcome_view.login_view.google_login_button.rx.tap.bind{ [weak self] in
			self!.button_touch_count = 2
			self!.welcome_viewModel.google_login(vc: self!)
		}.disposed(by: disposeBag)

		welcome_view.register_view.google_login_button.rx.tap.bind{ [weak self] in
			self!.button_touch_count = 2
			self!.welcome_viewModel.google_login(vc: self!)
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
			// Change view ( current view -> login_view )
			welcome_view.register_button.removeFromSuperview()
			welcome_view.register_view.removeFromSuperview()

			welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(welcome_view.header_view.snp.bottom).offset(screen_height / 6)
			}

			welcome_view.login_button.snp.remakeConstraints { make in
				make.top.equalTo(self.welcome_view.login_view.snp.bottom)
				make.left.right.equalTo(welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.login_view.alpha = 1.0
			}
			button_touch_count = 1
		}
		else if button_touch_count == 1
		{
			// Login
			welcome_viewModel.login(
				email: welcome_view.get_email(),
				password: welcome_view.get_password()) { [weak self] isSuccess in
					if isSuccess
					{
						if UserDefaults.standard.string(forKey: "name") == nil
						{
							self!.button_touch_count = 2
							// Change view ( current view -> name view )
							self!.welcome_view.login_view.removeFromSuperview()

							self!.welcome_view.name_view.snp.makeConstraints { make in
								make.top.equalTo(self!.welcome_view.welcome_label.snp.bottom).offset(50)
								make.left.right.equalTo(self!.welcome_view)
								make.height.equalTo(100)
							}

							self!.welcome_view.login_button.snp.remakeConstraints { make in
								make.top.equalTo(self!.welcome_view.name_view.snp.bottom)
								make.left.right.equalTo(self!.welcome_view).inset(30)
								make.height.equalTo(55)
							}
						}
						else
						{
							// Change VC ( current VC -> Main VC )
							let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
							guard let delegate = sceneDelegate else {
								print("sceneDelegate delegate error")
								return
							}
							delegate.changeRootVC(Main_ViewController(), animated: true)
						}
					}
					else
					{
						show_alert(
							viewController: self,
							title: "로그인",
							message: "로그인에 실패하였습니다.\n아이디와 비밀번호를 다시 확인해주세요.",
							button_title: "확인",
							handler: {_ in})
					}
				}
		}
		else if button_touch_count == 2
		{
			welcome_viewModel.register_name(
				name: welcome_view.name_view.name_textField.text ?? "") { [weak self] result in
				if result == "success"
				{
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					// Change VC ( current VC -> Main VC )
					let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
					guard let delegate = sceneDelegate else {
						print("sceneDelegate delegate error")
						return
					}
					delegate.changeRootVC(Main_ViewController(), animated: true)
				}
				else if result == "overlap"
				{
					show_alert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: {_ in})
				}
			}
		}
	}

	final func register_button_tap()
	{
		if button_touch_count == 0
		{
			// Change view ( current view -> register_view )
			welcome_view.login_button.removeFromSuperview()
			welcome_view.login_view.removeFromSuperview()

			welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(welcome_view.header_view.snp.bottom).offset(screen_height / 10)
			}

			welcome_view.register_button.snp.remakeConstraints { make in
				make.top.equalTo(self.welcome_view.register_view.snp.bottom)
				make.left.right.equalTo(welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.register_view.alpha = 1.0
			}
			button_touch_count = 1
		}
		else if button_touch_count == 1
		{
			if register_exec()
			{
				welcome_viewModel.register(
					email: welcome_view.get_email(),
					password: welcome_view.get_password()) { [weak self] isSuccess in
					if isSuccess
					{
						// Change view ( current view -> name_view )
						self?.welcome_view.register_view.removeFromSuperview()

						self?.welcome_view.name_view.snp.makeConstraints { make in
							make.top.equalTo(self!.welcome_view.welcome_label.snp.bottom).offset(50)
							make.height.equalTo(85)
							make.left.right.equalTo(self!.welcome_view)
						}

						self?.welcome_view.register_button.snp.remakeConstraints { make in
							make.top.equalTo(self!.welcome_view.name_view.snp.bottom).offset(15)
							make.left.right.equalTo(self!.welcome_view).inset(30)
							make.height.equalTo(55)
						}

						self?.button_touch_count = 2
					}
					else
					{
						show_alert(viewController: self,
								   title: "알림",
								   message: "회원 가입에 실패하였습니다.\n 정보를 다시 확인하여 주세요.",
								   button_title: "확인",
								   handler: {_ in})
					}
				}
			}
		}
		else if button_touch_count == 2
		{
			welcome_viewModel.register_name(
				name: welcome_view.name_view.name_textField.text ?? "") { [weak self] result in
				if result == "success"
				{
					// Change VC ( current VC -> Main VC )
					UserDefaults.standard.setValue(self!.welcome_view.name_view.name_textField.text ?? "", forKey: "name")
					let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
					guard let delegate = sceneDelegate else {
						print("sceneDelegate delegate error")
						return
					}
					delegate.changeRootVC(Main_ViewController(), animated: true)
				}
				else if result == "overlap"
				{
					show_alert(viewController: self, title: "알림", message: "중복된 닉네임입니다.", button_title: "확인", handler: {_ in})
				}
			}
		}
	} 

	final func register_exec() -> Bool
	{
		if welcome_view.register_view.email_textField.text == ""
		{
			show_alert(
				viewController: self, title: "알림", message: "이메일을 입력해주세요", button_title: "확인", handler: {_ in})
			return false
		}
		else if welcome_view.register_view.password_textField.text == ""
		{
			show_alert(
				viewController: self, title: "알림", message: "비밀 번호를 입력해주세요", button_title: "확인", handler: {_ in})
			return false
		}
		else if welcome_view.register_view.password_confirm_textField.text != welcome_view.register_view.password_textField.text
		{
			show_alert(
				viewController: self, title: "알림", message: "비밀 번호를 다시 확인하여 주세요.", button_title: "확인", handler: {_ in})
			return false
		}

		return true
	}
}
