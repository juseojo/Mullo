//
//  Setting_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 8/10/24.
//

import UIKit
import SnapKit

final class Setting_viewController: UIViewController
{
	let setting_view = Setting_view()
	let setting_viewModel = Setting_viewModel()

	override func viewDidLoad() {

		// Set basic layout
		view.addSubview(setting_view)
		setting_view.snp.makeConstraints { make in
			make.top.left.right.bottom.equalTo(view)
		}
	}
}
