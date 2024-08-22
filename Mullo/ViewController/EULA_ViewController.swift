//
//  EULA_ViewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/22/24.
//

import UIKit

import RxSwift
import SnapKit

final class EULA_ViewController: UIViewController {

	let EULA_view = EULA_View()
	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		view.backgroundColor = UIColor.clear

		view.addSubview(EULA_view)
		EULA_view.snp.makeConstraints { make in
			make.top.equalTo(self.view).inset(50)
			make.right.left.equalTo(self.view).inset(30)
			make.height.equalTo(screen_height * 0.6 + 130)
		}

		EULA_view.button.rx.tap
			.bind { [weak self] in
			self?.dismiss(animated: true)
		}.disposed(by: disposeBag)
	}
}
