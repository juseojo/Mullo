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
	var isCalled_function = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		welcome_view.login_button.rx.tap.bind{
			self.login_button_tap()
		}.disposed(by: disposeBag)

		welcome_view.register_button.rx.tap.bind{
			self.register_button_tap()
		}.disposed(by: disposeBag)

		view.addSubview(welcome_view)
		welcome_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(view)
		}
	}

	final func login_button_tap()
	{
		if isCalled_function == false
		{
			welcome_view.register_button.removeFromSuperview()
			welcome_view.register_view.removeFromSuperview()

			welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(welcome_view.header_view.snp.bottom).offset(screen_height / 6)
			}

			welcome_view.login_button.snp.remakeConstraints { make in
				make.left.right.equalTo(welcome_view).inset(30)
				make.bottom.equalTo(welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.login_view.alpha = 1.0
			}
			isCalled_function = true
		}
		else
		{
			print("have to login")
			welcome_viewModel.login(
				vc: self,
				email: welcome_view.register_view.email_textField.text!,
				password: welcome_view.register_view.password_textField.text!)
		}
	}

	final func register_button_tap()
	{
		if isCalled_function == false
		{
			welcome_view.login_button.removeFromSuperview()
			welcome_view.login_view.removeFromSuperview()

			welcome_view.welcome_label.snp.updateConstraints { make in
				make.top.equalTo(welcome_view.header_view.snp.bottom).offset(screen_height / 10)
			}

			welcome_view.register_button.snp.remakeConstraints { make in
				make.left.right.equalTo(welcome_view).inset(30)
				make.bottom.equalTo(welcome_view).inset(30)
				make.height.equalTo(55)
			}

			UIView.animate(withDuration: 1.5) {
				self.view.layoutIfNeeded()
			}
			UIView.animate(withDuration: 1, delay: 1) {
				self.welcome_view.register_view.alpha = 1.0
			}
			isCalled_function = true
		}
		else
		{
			if register_exec()
			{
				welcome_viewModel.register(
					email: welcome_view.register_view.email_textField.text!, password: welcome_view.register_view.password_textField.text!)
			}
		}
	}

	final func register_exec() -> Bool
	{
		if welcome_view.register_view.nick_name_textField.text == ""
		{
			show_alert(
				viewController: self, title: "알림", message: "닉네임을 입력해주세요", button_title: "확인", handler: {_ in})
			return false
		}
		else if welcome_view.register_view.email_textField.text == ""
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
