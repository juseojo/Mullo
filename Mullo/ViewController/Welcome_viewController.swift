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
	var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		welcome_view.login_button.rx.tap.bind{
			self.login_button_tap()
		}.disposed(by: disposeBag)
		view.addSubview(welcome_view)
		welcome_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(view)
		}
	}

	final func login_button_tap()
	{
		let login_view = Login_view()
		welcome_view.addSubview(login_view)
		welcome_view.register_button.removeFromSuperview()

		welcome_view.welcome_label.snp.updateConstraints { make in
			make.top.equalTo(welcome_view.header_view.snp.bottom).offset(screen_height / 6)
		}

		welcome_view.login_button.snp.remakeConstraints { make in
			make.left.right.equalTo(welcome_view).inset(30)
			make.bottom.equalTo(welcome_view).inset(30)
			make.height.equalTo(55)
		}

		login_view.snp.makeConstraints { make in
			make.top.equalTo(welcome_view.welcome_label.snp.bottom).offset(50)
			make.left.right.equalTo(view)
			make.bottom.equalTo(welcome_view.login_button.snp.top)
		}
	}
}
