//
//  Post_collectionView_cell.swift
//  Mullo
//
//  Created by seongjun cho on 4/17/24.
//

import UIKit

import Kingfisher
import RxSwift
import RealmSwift

final class Post_collectionView_cell : UICollectionViewCell, UIScrollViewDelegate {
	static let identifier = "post"
	var disposeBag = DisposeBag()
	var image_disposeBag = DisposeBag()
	let subject = BehaviorSubject<[String]>(value: [])
	var items: Observable<[String]> {
		return subject.compactMap { $0 }
	}
	var choice_button_vote_count = [String]()
	var buttons = [UIButton]()
	var post_num = -1

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

	var image_collectionView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()

		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 50
		flowLayout.itemSize = CGSize(width: 130, height: screen_height * 0.2 - 20)
		flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		flowLayout.minimumLineSpacing = 10

		let image_collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		image_collectionView.register(
			Image_collectionView_cell.self, forCellWithReuseIdentifier: Image_collectionView_cell.identifier)

		return image_collectionView
	}()

	var choice_view: UIView = {
		let choice_view = UIView()

		return choice_view
	}()

	var first_button: UIButton = {
		let first_button = UIButton()

		first_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		first_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		first_button.layer.borderWidth = 1.5

		return first_button
	}()

	var second_button: UIButton = {
		let second_button = UIButton()

		second_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		second_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		second_button.layer.borderWidth = 1.5

		return second_button
	}()

	var third_button: UIButton = {
		let third_button = UIButton()

		third_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		third_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		third_button.layer.borderWidth = 1.5

		return third_button
	}()

	var fourth_button: UIButton = {
		let fourth_button = UIButton()

		fourth_button.setTitleColor(UIColor(named: "REVERSE_SYS"), for: .normal)
		fourth_button.layer.borderColor = UIColor(named: "REVERSE_SYS")?.cgColor
		fourth_button.layer.borderWidth = 1.5

		return fourth_button
	}()

	var comments_button: UIButton = {
		let comments_button = UIButton()
		let button_image = UIImage(
			systemName: "ellipsis.bubble",
			withConfiguration: UIImage.SymbolConfiguration(pointSize: head_height * 0.5, weight: .bold, scale: .large))

		comments_button.setImage(button_image, for: .normal)
		comments_button.tintColor = UIColor(named: "REVERSE_SYS")

		return comments_button
	}()

	private var border_view: UIView = {
		let border_view = UIView()
		
		border_view.backgroundColor = UIColor.gray

		return border_view
	}()

	var touched_button_background_view: UIView = {
		let touched_button_background_view = UIView()

		touched_button_background_view.backgroundColor = UIColor.lightGray

		return touched_button_background_view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		self.buttons = [first_button, second_button, third_button, fourth_button]

		image_collectionView.rx.setDelegate(self).disposed(by: disposeBag)
		items.observe(on: MainScheduler.instance)
			.bind(to:image_collectionView.rx.items(
				cellIdentifier: Image_collectionView_cell.identifier,
				cellType: Image_collectionView_cell.self)) { row, item, cell in
					cell.image_view.kf.setImage(with: URL(string: item))
		   }.disposed(by: self.image_disposeBag)

		self.backgroundColor = UIColor(named: "NATURAL")

		self.addSubview(name_label)
		self.addSubview(time_label)
		self.addSubview(post_textView)
		self.addSubview(image_collectionView)
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
		}

		image_collectionView.snp.makeConstraints { make in
			make.top.equalTo(post_textView.snp.bottom)
			make.left.right.equalTo(self).inset(10)
		}

		choice_view.snp.makeConstraints { make in
			make.top.equalTo(image_collectionView.snp.bottom)
			make.left.right.equalTo(self).inset(10)
		}

		first_button.snp.makeConstraints { make in
			make.top.left.right.equalTo(choice_view)
			make.height.equalTo(25)
		}

		second_button.snp.makeConstraints { make in
			make.top.equalTo(first_button.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(choice_view)
			make.height.equalTo(25)
		}

		comments_button.snp.makeConstraints { make in
			make.top.equalTo(choice_view.snp.bottom)
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(border_view.snp.top)
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

		time_label.text = nil
		name_label.text = nil
		for button in buttons
		{
			button.isEnabled = true
			button.setTitle(nil, for: .normal)
		}

		third_button.removeFromSuperview()
		fourth_button.removeFromSuperview()
		touched_button_background_view.snp.removeConstraints()
		touched_button_background_view.removeFromSuperview()
		post_num = -1
		disposeBag = DisposeBag()

		second_button.snp.remakeConstraints { make in
			make.top.equalTo(first_button.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(choice_view)
			make.height.equalTo(25)
		}
		self.subject.onNext([])

		for subview in choice_view.subviews
		{
			if (!subview.isKind(of: UIButton.self))
			{
				subview.removeFromSuperview()
			}
		}
	}

	func add_third_button(button_text: String)
	{
		choice_view.addSubview(third_button)

		//remove bottom layout
		second_button.snp.remakeConstraints { make in
			make.top.equalTo(first_button.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_view)
			make.height.equalTo(25)
		}

		//new button layout
		third_button.snp.makeConstraints { make in
			make.top.equalTo(second_button.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(choice_view)
			make.height.equalTo(25)
		}

		third_button.setTitle(button_text, for: .normal)
	}

	func add_fourth_button(button_text: String)
	{
		choice_view.addSubview(fourth_button)

		//remove bottom layout
		third_button.snp.remakeConstraints { make in
			make.top.equalTo(second_button.snp.bottom).inset(-10)
			make.left.right.equalTo(choice_view)
			make.height.equalTo(25)
		}

		//new button layout
		fourth_button.snp.makeConstraints { make in
			make.top.equalTo(third_button.snp.bottom).inset(-10)
			make.left.right.bottom.equalTo(choice_view)
			make.height.equalTo(25)
		}

		fourth_button.setTitle(button_text, for: .normal)
	}
}
