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

		name_label.font = UIFont(name: "GillSans-SemiBold", size: 15)

		return name_label
	}()

	var time_label: UILabel = {
		let time_label = UILabel()

		time_label.font = UIFont(name: "GillSans-SemiBold", size: 10)
		time_label.textColor = UIColor.gray

		return time_label
	}()

	var post_textView: UITextView = {
		let post_textView = UITextView()

		post_textView.textColor = UIColor(named: "REVERSE_SYS")
		post_textView.font = UIFont(name: "GillSans-SemiBold", size: 15)
		post_textView.isEditable = false
		post_textView.isScrollEnabled = false

		return post_textView
	}()

	var choice_view: UIView = {
		let choice_view = UIView()

		return choice_view
	}()

	var first_button: UIButton = {
		let first_button = UIButton()

		first_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		first_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		first_button.layer.borderWidth = 1

		return first_button
	}()

	var second_button: UIButton = {
		let second_button = UIButton()

		second_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		second_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		second_button.layer.borderWidth = 1

		return second_button
	}()

	var third_button: UIButton = {
		let third_button = UIButton()

		third_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		third_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		third_button.layer.borderWidth = 1

		return third_button
	}()

	var fourth_button: UIButton = {
		let fourth_button = UIButton()

		fourth_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		fourth_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		fourth_button.layer.borderWidth = 1

		return fourth_button
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
		choice_view.addSubview(first_button)
		choice_view.addSubview(second_button)

		self.addSubview(comments_button)
		self.addSubview(border_view)

		name_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(10)
			make.left.equalTo(self).inset(12)
			make.height.equalTo(20)
		}

		time_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(10)
			make.left.equalTo(name_label.snp.right).inset(-20)
			make.height.equalTo(name_label)
		}

		post_textView.snp.makeConstraints { make in
			make.top.equalTo(name_label.snp.bottom).inset(-10)
			make.left.right.equalTo(self).inset(10)
			make.bottom.equalTo(choice_view.snp.top)
		}

		choice_view.snp.makeConstraints { make in
			make.top.equalTo(post_textView.snp.bottom)
			make.left.right.equalTo(self).inset(10)
			make.bottom.equalTo(comments_button.snp.top).inset(-10)
		}

		first_button.snp.makeConstraints { make in
			make.top.left.right.equalTo(choice_view)
			make.height.equalTo(20)
		}

		second_button.snp.makeConstraints { make in
			make.top.equalTo(first_button.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_view)
			make.height.equalTo(20)
		}

		comments_button.snp.makeConstraints { make in
			make.top.equalTo(choice_view.snp.bottom).inset(-10)
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(border_view.snp.top).inset(-10)
			make.height.equalTo(50)
		}

		border_view.snp.makeConstraints { make in
			make.left.right.bottom.equalTo(self)
			make.height.equalTo(1)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {

		first_button.setTitle(nil, for: .normal)
		second_button.setTitle(nil, for: .normal)
		third_button.setTitle(nil, for: .normal)
		fourth_button.setTitle(nil, for: .normal)
		time_label.text = nil
		name_label.text = nil
		third_button.snp.removeConstraints()
		fourth_button.snp.removeConstraints()
		third_button.removeFromSuperview()
		fourth_button.removeFromSuperview()
	}

	func add_third_button(button_text: String)
	{
		choice_view.addSubview(third_button)
		third_button.snp.makeConstraints { make in
			make.top.equalTo(second_button.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_view)
			make.height.equalTo(20)
		}
		third_button.setTitle(button_text, for: .normal)
	}

	func add_fourth_button(button_text: String)
	{
		choice_view.addSubview(fourth_button)
		fourth_button.snp.makeConstraints { make in
			make.top.equalTo(third_button.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_view)
			make.height.equalTo(20)
		}
		fourth_button.setTitle(button_text, for: .normal)
	}
}
