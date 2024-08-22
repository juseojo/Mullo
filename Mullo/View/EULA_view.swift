//
//  EULA_view.swift
//  Mullo
//
//  Created by seongjun cho on 8/22/24.
//

import UIKit

import SnapKit

final class EULA_View: UIView {

	var title_label: UILabel = {
		let title_label = UILabel()

		title_label.textAlignment = .center
		title_label.textColor = UIColor(named: "REVERSE_SYS")
		title_label.text = "서비스 이용약관 동의서 / 최종 사용자 사용권 계약"
		title_label.font = UIFont.systemFont(ofSize: 15)

		return title_label
	}()

	var message_textView: UITextView = {
		let message_textView = UITextView()

		message_textView.textAlignment = .center
		message_textView.textColor = UIColor(named: "REVERSE_SYS")
		message_textView.font = UIFont.systemFont(ofSize: 10)
		message_textView.text = eula_text

		return message_textView
	}()

	var button: UIButton = {
		let button = UIButton()

		button.setTitle("확인", for: .normal)
		button.backgroundColor = UIColor(named: "REVERSE_SYS")
		button.setTitleColor(UIColor(named: "NATURAL"), for: .normal)
		button.layer.cornerRadius = 5
		button.layer.masksToBounds = true

		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(title_label)
		addSubview(message_textView)
		addSubview(button)

		self.backgroundColor = UIColor(named: "NATURAL")
		self.layer.cornerRadius = 10
		self.layer.masksToBounds = true

		title_label.snp.makeConstraints { make in
			make.top.equalTo(self).inset(20)
			make.left.right.equalTo(self).inset(10)
			make.height.equalTo(title_label.font.pointSize)
		}

		message_textView.snp.makeConstraints { make in
			make.top.equalTo(title_label.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(20)
			make.height.equalTo(screen_height * 0.6)
		}

		button.snp.makeConstraints { make in
			make.top.equalTo(message_textView.snp.bottom).inset(-20)
			make.left.right.equalTo(self).inset(80)
			make.bottom.equalTo(self).inset(20)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
