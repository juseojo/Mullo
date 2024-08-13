//
//  Setting_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/10/24.
//

import UIKit
import SnapKit
import RxSwift

final class Setting_viewController: UIViewController
{
	let setting_view = Setting_view()
	let setting_viewModel = Setting_viewModel()
	let disposeBag = DisposeBag()

	override func viewDidLoad() {

		// Basic setting
		view.backgroundColor = UIColor(named: "NATURAL")
		self.navigationController?.isNavigationBarHidden = true
		
		// Set basic layout
		view.addSubview(setting_view)
		setting_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(view)
		}

		// tap event - back button
		setting_view.back_button.rx.tap.bind { [weak self] in
			self!.navigationController?.popViewController(animated:true)
		}.disposed(by: disposeBag)

		// tap event - question button
		setting_view.question_button.rx.tap.bind { [weak self] in
			self!.question_button_touch()
		}.disposed(by: disposeBag)

		// tap event - right button
		setting_view.right_button.rx.tap.bind { [weak self] in
			self!.right_button_touch()
		}.disposed(by: disposeBag)

		// tap event - logout button
		setting_view.logout_button.rx.tap.bind { [weak self] in
			self!.logout_button_touch()
		}.disposed(by: disposeBag)
	}

	private func question_button_touch()
	{
		let alert = UIAlertController(title: "건의하기", message: "건의할 내용을 입력해주세요", preferredStyle: .alert)
		let send_action = UIAlertAction(title: "보내기", style: .default, handler: {_ in 
			print(alert.textFields!.first!.text!)
			// have to send it
		})
		let cancel_action = UIAlertAction(title: "취소", style: .cancel, handler: nil)

		alert.addTextField()
		alert.addAction(send_action)
		alert.addAction(cancel_action)

		AlertHelper.showAlert(alert: alert)
	}

	private func right_button_touch()
	{
		let vc = Right_viewController()
		self.present(vc, animated: true)
	}

	private func logout_button_touch()
	{
		let logout_alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
		let logout_action = UIAlertAction(title: "예", style: .default, handler: { [weak self] _ in
			UserDefaults.standard.set(nil, forKey: "name")
			self!.navigationController?.setViewControllers([Welcome_viewController(),], animated: true)
		})
		let cancel_action = UIAlertAction(title: "아니요", style: .cancel, handler: nil)

		logout_alert.addAction(logout_action)
		logout_alert.addAction(cancel_action)

		self.present(logout_alert, animated: true)
	}
}
