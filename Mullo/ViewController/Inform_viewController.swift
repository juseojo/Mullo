//
//  Inform_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/6/24.
//

import UIKit
import SnapKit

final class Inform_viewController: UIViewController
{
	let inform_view = Inform_view()
	let inform_viewModel = Inform_viewModel()

	override func viewDidLoad() {

		// Set basic layout
		view.addSubview(inform_view)
		inform_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(view)
		}
	}
}
