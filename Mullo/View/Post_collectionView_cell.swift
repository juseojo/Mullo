//
//  Post_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 4/17/24.
//

import UIKit

class Post_collectionView_cell : UICollectionViewCell {
	static let identifier = "main"

	private var name_label: UILabel = {
		let name_label = UILabel()
		return name_label
	}()

	private var time_label: UILabel = {
		let time_label = UILabel()
		return time_label
	}()

	private var post_textView: UITextView = {
		let post_textView = UITextView()
		return post_textView
	}()

	private var choice_view: UIView = {
		let choice_view = UIView()

		return choice_view
	}()

	private var comments_button: UIButton = {
		let comments_button = UIButton()

		comments_button.setImage(UIImage(systemName: "ellipsis.bubble"), for: .normal)

		return comments_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor(named: "NATURAL")

		self.addSubview(name_label)
		self.addSubview(time_label)
		self.addSubview(post_textView)
		self.addSubview(choice_view)
		self.addSubview(comments_button)

		name_label.snp.makeConstraints { make in
			make.top.left.equalTo(self).inset(10)
			make.height.equalTo(20)
		}

		time_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(10)
			make.left.equalTo(name_label.snp.right)
			make.height.equalTo(name_label)
		}

		post_textView.snp.makeConstraints { make in
			make.top.equalTo(name_label.snp.bottom).inset(10)
			make.left.right.equalTo(self).inset(10)
			make.bottom.equalTo(comments_button.snp.top).inset(5)
		}

		comments_button.snp.makeConstraints { make in
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(self).inset(10)
			make.width.height.equalTo(50)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
