//
//  Post_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 4/17/24.
//

import UIKit

class Post_collectionView_cell : UICollectionViewCell {
	static let identifier = "post"

	var name_label: UILabel = {
		let name_label = UILabel()

		return name_label
	}()

	var time_label: UILabel = {
		let time_label = UILabel()

		return time_label
	}()

	var post_textView: UITextView = {
		let post_textView = UITextView()

		post_textView.textColor = UIColor(named: "REVERSE_SYS")
		post_textView.isEditable = false

		return post_textView
	}()

	private var choice_view: UIView = {
		let choice_view = UIView()

		return choice_view
	}()

	var comments_button: UIButton = {
		let comments_button = UIButton()
		let button_image = UIImage(
			systemName: "ellipsis.bubble",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: head_height * 0.5, weight: .bold, scale: .large))

		comments_button.setImage(button_image, for: .normal)
		comments_button.tintColor = UIColor.black

		return comments_button
	}()

	private var border_view: UIView = {
		let border_view = UIView()
		
		border_view.backgroundColor = UIColor.gray

		return border_view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(named: "NATURAL")

		self.addSubview(name_label)
		self.addSubview(time_label)
		self.addSubview(post_textView)
		self.addSubview(choice_view)
		self.addSubview(comments_button)
		self.addSubview(border_view)

		name_label.snp.makeConstraints { make in
			make.top.equalTo(self)
			make.left.equalTo(self).inset(10)
			make.height.equalTo(20)
		}

		time_label.snp.makeConstraints { make in
			make.top.equalTo(self)
			make.left.equalTo(name_label.snp.right).inset(-20)
			make.height.equalTo(name_label)
		}

		post_textView.snp.makeConstraints { make in
			make.top.equalTo(name_label.snp.bottom).inset(-10)
			make.left.right.equalTo(self).inset(10)
			make.bottom.equalTo(comments_button.snp.top).inset(5)
		}

		comments_button.snp.makeConstraints { make in
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(border_view.snp.top).inset(-10)
		}
		border_view.snp.makeConstraints { make in
			make.left.right.bottom.equalTo(self)
			make.height.equalTo(1)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
