//
//  MyPost_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 8/6/24.
//

import UIKit
import SnapKit

class MyPost_collectionView_cell: Post_collectionView_cell {
	var delete_button: UIButton = {
		let delete_button = UIButton()
		let delete_button_image = UIImage(
			systemName: "xmark", 
			withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large))

		delete_button.setImage(delete_button_image, for: .normal)
		delete_button.tintColor = UIColor(named: "REVERSE_SYS")
		delete_button.contentMode = .scaleAspectFit

		return delete_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		report_button.isHidden = true
		report_button.isEnabled = false

		addSubview(delete_button)
		delete_button.snp.makeConstraints { make in
			make.top.right.equalTo(self).inset(10)
			make.width.height.equalTo(20)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
