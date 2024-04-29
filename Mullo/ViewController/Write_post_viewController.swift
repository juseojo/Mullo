//
//  Write_post_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit

import SnapKit
import RxSwift

class Write_post_viewController: UIViewController {

	var write_post_view = Write_post_view()
	var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		write_post_view.back_button.rx.tap
			.bind{
				self.back_button_touch()
			}.disposed(by: disposeBag)

		//layout
		self.view.addSubview(write_post_view)
		write_post_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}
	}

	func back_button_touch()
	{
		self.navigationController?.popViewController(animated:true)
	}
}
