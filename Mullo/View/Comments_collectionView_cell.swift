//
//  Comments_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 7/14/24.
//

import UIKit

class Comments_collectionView_cell: UICollectionViewCell
{
	static let identifier = "comments"

	var name_label: UILabel = {
		let name_label = UILabel()

		return name_label
	}()

	var time_label: UILabel = {
		let time_label = UILabel()

		return time_label
	}()

	var report_button: UIButton = {
		let report_button = UIButton()

		report_button.setImage(UIImage(systemName: "flag"), for: .normal)
		report_button.tintColor = UIColor(named: "REVERSE_SYS")

		return report_button
	}()

	var comment_label: UILabel = {
		let comment_label = UILabel()

		comment_label.font = UIFont(name: "SeoulHangangM", size: 15)
		comment_label.tintColor = UIColor(named: "REVERSE_SYS")

		return comment_label
	}()

	var up_button: UIButton = {
		let up_button = UIButton()

		up_button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
		up_button.tintColor = UIColor(named: "REVERSE_SYS")

		return up_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor(named: "NATURAL")

		name_label.snp.makeConstraints { make in
			make.top.left.equalTo(self).inset(-10)
			make.height.equalTo(15)
			make.width.equalTo(40)
		}

		time_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(-10)
			make.left.equalTo(name_label.snp.right).inset(10)
		}

		report_button.snp.makeConstraints { make in
			make.top.right.equalTo(self)
			make.width.height.equalTo(25)
		}

		comment_label.snp.makeConstraints { make in
			make.top.equalTo(name_label.snp.bottom).inset(-10)
			make.left.equalTo(self).inset(10)
			make.right.equalTo(report_button.snp.left)
			make.height.equalTo(25)
		}

		up_button.snp.makeConstraints { make in
			make.top.equalTo(comment_label.snp.bottom).inset(-10)
			make.left.bottom.equalTo(self)
			make.width.equalTo(50)
		}
	}

	final func nameLabel_width_setting(width: Int)
	{
		name_label.snp.updateConstraints { make in
			make.width.equalTo(width)
		}
	}

	final func commentLabel_height_setting(height: Int)
	{
		comment_label.snp.updateConstraints { make in
			make.height.equalTo(height)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
