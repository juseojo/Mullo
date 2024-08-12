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
		setting_view.back_button.rx.tap.bind {
			self.navigationController?.popViewController(animated:true)
		}.disposed(by: disposeBag)

		// tap event - question button
		setting_view.question_button.rx.tap.bind { [weak self] in
			self!.question_button_touch()
		}.disposed(by: disposeBag)

		// tap event - right button
		setting_view.right_button.rx.tap.bind { [weak self] in
			self!.right_button_touch()
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
		self.present(vc, animated: false)
	}
}
