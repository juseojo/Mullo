//
//  Comment_view.swift
//  Mullo
//
//  Created by seongjun cho on 7/5/24.
//

import UIKit

final class Comments_view: UIView
{
	private var headder_view: UIView = {
		let headder_view = UIView()

		headder_view.backgroundColor = UIColor(named: "NATURAL")

		return headder_view
	}()

	private var grabBar_view: UIView = {
		let grabBar_view = UIView()
		
		grabBar_view.backgroundColor = UIColor.gray
		grabBar_view.layer.masksToBounds = true
		grabBar_view.layer.cornerRadius = 3.0

		return grabBar_view
	}()

	private var comment_label: UILabel = {
		let comment_label = UILabel()
		
		comment_label.text = "댓글"
		comment_label.tintColor = UIColor(named: "REVERSE_SYS")
		comment_label.font = UIFont(name: "Urbanist-Bold", size: 20)

		return comment_label
	}()

	private var popularSort_button: UIButton = {
		let popularSort_button = UIButton()

		popularSort_button.setTitle("인기순", for: .normal)
		popularSort_button.tintColor = UIColor(named: "REVERSE_SYS")
		popularSort_button.titleLabel?.font = UIFont(name: "Urbanist-Bold", size: 15)!
		popularSort_button.backgroundColor = UIColor.gray
		popularSort_button.layer.masksToBounds = true
		popularSort_button.layer.cornerRadius = 3.0

		return popularSort_button
	}()

	private var recentSort_button: UIButton = {
		let recentSort_button = UIButton()

		recentSort_button.setTitle("최신순", for: .normal)
		recentSort_button.tintColor = UIColor(named: "REVERSE_SYS")
		recentSort_button.titleLabel?.font = UIFont(name: "Urbanist-Bold", size: 15)!
		recentSort_button.backgroundColor = UIColor.gray
		recentSort_button.layer.masksToBounds = true
		recentSort_button.layer.cornerRadius = 3.0

		return recentSort_button
	}()

	var close_button: UIButton = {
		let close_button = UIButton()

		close_button.setImage(
			UIImage(systemName: "xmark")?.resized(to: CGSize(width: 30, height: 30)), for: .normal)
		close_button.tintColor = UIColor(named: "REVERSE_SYS")
		close_button.contentMode = .scaleAspectFit

		return close_button
	}()

	private var headder_divider_view: UIView = {
		let headder_divider_view = UIView()

		headder_divider_view.backgroundColor = UIColor.gray

		return headder_divider_view
	}()

	var comment_textview: UITextView = {
		let comment_textview = UITextView()
		let placeholderLabel = UILabel()

		comment_textview.layer.borderColor = UIColor.lightGray.cgColor
		comment_textview.layer.borderWidth = 1.0
		comment_textview.layer.masksToBounds = true
		comment_textview.layer.cornerRadius = 5.0
		comment_textview.font = UIFont(name: "SeoulHangangM", size: 15)

		return comment_textview
	}()

	let placeholder_label: UILabel = {
		let placeholder_label = UILabel()

		placeholder_label.text = "댓글을 입력해주세요..."
		placeholder_label.adjustsFontSizeToFitWidth = true
		placeholder_label.minimumScaleFactor = 15
		placeholder_label.textColor = .lightGray

		return placeholder_label
	}()

	private var comment_add_button: UIButton = {
		let comment_add_button = UIButton()

		comment_add_button.setImage(
			UIImage(systemName: "paperplane")?.resized(to: CGSize(width: 30, height: 30)), for: .normal)
		comment_add_button.tintColor = UIColor(named: "REVERSE_SYS")
		comment_add_button.imageView!.contentMode = .scaleAspectFit

		return comment_add_button
	}()

	private var commentAdd_divier_view: UIView = {
		let commentAdd_divier_view = UIView()

		commentAdd_divier_view.backgroundColor = UIColor.gray

		return commentAdd_divier_view
	}()

	private var comments_collectionView: UICollectionView = {
		let comments_collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

		return comments_collectionView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(headder_view)
		headder_view.addSubview(grabBar_view)
		headder_view.addSubview(comment_label)
		headder_view.addSubview(popularSort_button)
		headder_view.addSubview(recentSort_button)
		headder_view.addSubview(close_button)
		addSubview(headder_divider_view)
		addSubview(comment_textview)
		comment_textview.addSubview(placeholder_label)
		addSubview(comment_add_button)
		addSubview(commentAdd_divier_view)
		addSubview(comments_collectionView)

		headder_view.snp.makeConstraints { make in
			make.top.equalTo(self).inset(screen_height * 0.3)
			make.left.right.equalTo(self)
			make.bottom.equalTo(commentAdd_divier_view.snp.top)
		}

		grabBar_view.snp.makeConstraints { make in
			make.centerX.equalTo(self.snp.centerX)
			make.top.equalTo(headder_view).inset(5)
			make.width.equalTo(40)
			make.height.equalTo(5)
		}

		comment_label.snp.makeConstraints { make in
			make.top.equalTo(grabBar_view.snp.bottom).inset(-10)
			make.left.equalTo(self).inset(15)
			make.height.equalTo(30)
			make.width.equalTo(40)
		}

		popularSort_button.snp.makeConstraints { make in
			make.top.equalTo(grabBar_view.snp.bottom).inset(-10)
			make.left.equalTo(comment_label.snp.right).inset(-15)
			make.height.equalTo(30)
			make.width.equalTo(70)
		}

		recentSort_button.snp.makeConstraints { make in
			make.top.equalTo(grabBar_view.snp.bottom).inset(-10)
			make.left.equalTo(popularSort_button.snp.right).inset(-10)
			make.height.equalTo(30)
			make.width.equalTo(70)
		}

		close_button.snp.makeConstraints { make in
			make.top.equalTo(grabBar_view.snp.bottom)
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(comment_label.snp.bottom)
			make.width.equalTo(50)
		}

		headder_divider_view.snp.makeConstraints { make in
			make.top.equalTo(comment_label.snp.bottom).inset(-10)
			make.left.right.equalTo(self)
			make.height.equalTo(1)
		}

		comment_textview.snp.makeConstraints { make in
			make.top.equalTo(headder_divider_view.snp.bottom).inset(-10)
			make.left.equalTo(self).inset(15)
			make.right.equalTo(comment_add_button.snp.left).inset(-10)
			make.height.equalTo(35)
		}

		placeholder_label.snp.makeConstraints { make in
			make.centerY.equalTo(comment_textview)
			make.left.equalTo(comment_textview).inset(5)
			make.right.equalTo(comment_textview)
		}

		comment_add_button.snp.makeConstraints { make in
			make.top.equalTo(comment_textview.snp.top)
			make.right.equalTo(self).inset(10)
			make.bottom.equalTo(comment_textview.snp.bottom)
			make.width.equalTo(30)
		}

		commentAdd_divier_view.snp.makeConstraints { make in
			make.top.equalTo(comment_textview.snp.bottom).inset(-10)
			make.left.right.equalTo(self)
			make.height.equalTo(1)
		}
		
		comments_collectionView.snp.makeConstraints { make in
			make.top.equalTo(commentAdd_divier_view.snp.bottom)
			make.left.right.bottom.equalTo(self)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
