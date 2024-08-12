//
//  Right_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/12/24.
//

import UIKit
import SnapKit

class Right_viewController: UIViewController {

	let right_view = Right_view()

	override func viewDidLoad() {

		// Basic setting
		view.backgroundColor = UIColor(named: "NATURAL")
		self.navigationController?.isNavigationBarHidden = true

		// Set basic layout
		view.addSubview(right_view)
		right_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(view)
		}
	}
}
