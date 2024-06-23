//
//  Write_post_view.swift
//  Mullo
//
//  Created by seongjun cho on 4/28/24.
//

import UIKit

import SnapKit

final class Write_post_view: UIView {

	private var scroll_view: UIScrollView = {
		let scroll_view = UIScrollView()

		scroll_view.translatesAutoresizingMaskIntoConstraints = false

		return scroll_view
	}()

	var back_button: UIButton = {
		let back_button = UIButton()

		back_button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
		back_button.tintColor = UIColor(named: "REVERSE_SYS")

		return back_button
	}()

	private var post_label: UILabel = {
		let post_label = UILabel()

		post_label.text = "내용"
		post_label.font = UIFont(name: "SeoulHangangM", size: 20)

		return post_label
	}()

	var post_text_view: UITextView = {
		let post_text_view = UITextView()

		post_text_view.layer.borderColor = UIColor.lightGray.cgColor
		post_text_view.layer.borderWidth = 1.0
		post_text_view.backgroundColor = UIColor.white
		post_text_view.layer.cornerRadius = 5
		post_text_view.clipsToBounds = true
		post_text_view.font = UIFont(name: "SeoulHangangM", size: 10)
		post_text_view.textColor = UIColor.black

		return post_text_view
	}()

	private var image_label: UILabel = {
		let image_label = UILabel()

		image_label.text = "사진"
		image_label.font = UIFont(name: "SeoulHangangM", size: 20)

		return image_label
	}()

	var image_collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()

		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 50
		flowLayout.itemSize = CGSize(width: 130, height: screen_height * 0.25 - 20)
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		flowLayout.minimumLineSpacing = 10

		let image_collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		image_collectionView.register(
			Image_collectionView_cell.self, forCellWithReuseIdentifier: Image_collectionView_cell.identifier)

		image_collectionView.layer.borderColor = UIColor.lightGray.cgColor
		image_collectionView.layer.borderWidth = 1.0
		image_collectionView.layer.cornerRadius = 5.0
		image_collectionView.clipsToBounds = true

		return image_collectionView
	}()

	private var choice_label: UILabel = {
		let choice_label = UILabel()

		choice_label.text = "선택지"
		choice_label.font = UIFont(name: "SeoulHangangM", size: 20)

		return choice_label
	}()

	private var choice_contain_view: UIView = {
		let choice_contain_view = UIView()

		return choice_contain_view
	}()

	var first_choice_textField: UITextField = {
		let first_choice_textField = UITextField()

		first_choice_textField.layer.borderColor = UIColor.lightGray.cgColor
		first_choice_textField.layer.borderWidth = 1.0
		first_choice_textField.backgroundColor = UIColor.white
		first_choice_textField.layer.cornerRadius = 5.0
		first_choice_textField.clipsToBounds = true
		first_choice_textField.font = UIFont(name: "SeoulHangangM", size: 10)

		return first_choice_textField
	}()

	var second_choice_textField: UITextField = {
		let second_choice_textField = UITextField()

		second_choice_textField.layer.borderColor = UIColor.lightGray.cgColor
		second_choice_textField.layer.borderWidth = 1.0
		second_choice_textField.backgroundColor = UIColor.white
		second_choice_textField.layer.cornerRadius = 5.0
		second_choice_textField.clipsToBounds = true
		second_choice_textField.font = UIFont(name: "SeoulHangangM", size: 10)

		return second_choice_textField
	}()

	var third_choice_textField: UITextField = {
		let third_choice_textField = UITextField()

		third_choice_textField.layer.borderColor = UIColor.lightGray.cgColor
		third_choice_textField.layer.borderWidth = 1.0
		third_choice_textField.backgroundColor = UIColor.white
		third_choice_textField.layer.cornerRadius = 5.0
		third_choice_textField.clipsToBounds = true
		third_choice_textField.font = UIFont(name: "SeoulHangangM", size: 10)

		return third_choice_textField
	}()

	var fourth_choice_textField: UITextField = {
		let fourth_choice_textField = UITextField()

		fourth_choice_textField.layer.borderColor = UIColor.lightGray.cgColor
		fourth_choice_textField.layer.borderWidth = 1.0
		fourth_choice_textField.backgroundColor = UIColor.white
		fourth_choice_textField.layer.cornerRadius = 5.0
		fourth_choice_textField.clipsToBounds = true
		fourth_choice_textField.font = UIFont(name: "SeoulHangangM", size: 10)

		return fourth_choice_textField
	}()

	var choice_plus_button: UIButton = {
		let choice_plus_button = UIButton()

		choice_plus_button.setImage(UIImage(systemName: "plus"), for: .normal)
		choice_plus_button.tintColor = UIColor(named: "REVERSE_SYS")

		return choice_plus_button
	}()

	var choice_minus_button: UIButton = {
		let choice_minus_button = UIButton()

		choice_minus_button.setImage(UIImage(systemName: "minus"), for: .normal)
		choice_minus_button.tintColor = UIColor(named: "REVERSE_SYS")

		return choice_minus_button
	}()

	var posting_button: UIButton = {
		let posting_button = UIButton()

		posting_button.setTitle("게시하기", for: .normal)
		posting_button.titleLabel?.textColor = UIColor.black
		posting_button.backgroundColor = UIColor.gray
		posting_button.layer.cornerRadius = 5.0
		posting_button.clipsToBounds = true

		return posting_button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.backgroundColor = UIColor(named: "NATURAL")

		addSubview(scroll_view)
		scroll_view.addSubview(back_button)
		scroll_view.addSubview(post_label)
		scroll_view.addSubview(post_text_view)
		scroll_view.addSubview(image_label)
		scroll_view.addSubview(image_collectionView)
		scroll_view.addSubview(choice_label)
		scroll_view.addSubview(choice_contain_view)
		choice_contain_view.addSubview(first_choice_textField)
		choice_contain_view.addSubview(second_choice_textField)
		scroll_view.addSubview(choice_plus_button)
		scroll_view.addSubview(choice_minus_button)
		scroll_view.addSubview(posting_button)

		scroll_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self)
		}

		back_button.snp.makeConstraints { make in
			make.top.left.equalTo(scroll_view).inset(20)
		}

		post_label.snp.makeConstraints { make in
			make.top.equalTo(back_button.snp.bottom).inset(-10)
			make.left.right.equalTo(scroll_view).inset(20)
		}

		post_text_view.snp.makeConstraints { make in
			make.top.equalTo(post_label.snp.bottom).inset(-10)
			make.left.right.equalTo(scroll_view).inset(20)
			make.width.equalTo(screen_width - 40)
			make.height.equalTo(screen_height * 0.3)
		}

		image_label.snp.makeConstraints { make in
			make.top.equalTo(post_text_view.snp.bottom).inset(-10)
			make.left.equalTo(scroll_view).inset(20)
		}

		image_collectionView.snp.makeConstraints { make in
			make.top.equalTo(image_label.snp.bottom).inset(-10)
			make.left.right.equalTo(scroll_view).inset(20)
			make.height.equalTo(screen_height * 0.25)
		}

		choice_label.snp.makeConstraints { make in
			make.top.equalTo(image_collectionView.snp.bottom).inset(-10)
			make.left.equalTo(scroll_view).inset(20)
		}

		choice_contain_view.snp.makeConstraints { make in
			make.top.equalTo(choice_label.snp.bottom).inset(-10)
			make.left.right.equalTo(scroll_view).inset(30)
			make.height.equalTo(80)
			make.bottom.equalTo(choice_plus_button.snp.top)
		}

		first_choice_textField.snp.makeConstraints { make in
			make.top.left.right.equalTo(choice_contain_view)
			make.height.equalTo(30)
		}

		second_choice_textField.snp.makeConstraints { make in
			make.top.equalTo(first_choice_textField.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_contain_view)
			make.height.equalTo(30)
		}

		choice_minus_button.snp.makeConstraints { make in
			make.top.equalTo(choice_contain_view.snp.bottom)
			make.right.equalTo(choice_contain_view)
			make.height.width.equalTo(50)
		}

		choice_plus_button.snp.makeConstraints { make in
			make.top.equalTo(choice_contain_view.snp.bottom)
			make.right.equalTo(choice_minus_button.snp.left).inset(10)
			make.height.width.equalTo(50)
		}

		posting_button.snp.makeConstraints { make in
			make.top.equalTo(choice_plus_button.snp.bottom).inset(-50)
			make.left.right.equalTo(scroll_view).inset(50)
			make.bottom.equalTo(scroll_view)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func add_third_choice_textField()
	{
		choice_contain_view.addSubview(third_choice_textField)
		third_choice_textField.snp.makeConstraints { make in
			make.top.equalTo(second_choice_textField.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_contain_view)
			make.height.equalTo(30)
		}
		choice_contain_view.snp.updateConstraints { make in
			make.height.equalTo(120)
		}
	}

	func add_fourth_choice_textField()
	{
		choice_contain_view.addSubview(fourth_choice_textField)
		fourth_choice_textField.snp.makeConstraints { make in
			make.top.equalTo(third_choice_textField.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_contain_view)
			make.height.equalTo(30)
		}
		choice_contain_view.snp.updateConstraints { make in
			make.height.equalTo(160)
		}
	}

	func delete_textField(target: UITextField)
	{
		target.snp.removeConstraints()
		target.removeFromSuperview()
		target.text = ""
		choice_contain_view.snp.updateConstraints { make in
			make.height.equalTo(choice_contain_view.bounds.height - 40)
		}
	}
}
