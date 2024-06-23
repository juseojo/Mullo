//
//  util.swift
//  Mullo
//
//  Created by seongjun cho on 4/16/24.
//

import UIKit

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05
let top_inset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0

func show_alert(
	viewController: UIViewController?,
	title: String,
	message: String,
	button_title: String,
	handler: ((UIAlertAction) -> Void)?)
{
	let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
	let action = UIAlertAction(title: button_title, style: .default, handler: handler)
	alert.addAction(action)
	viewController?.present(alert, animated: true)
}

extension UIImage {
	func resize(ratio: Float) -> UIImage
	{
		let new_width = Double(Float(self.size.width) * ratio)
		let new_height = Double(Float(self.size.height) * ratio)
		let new_size = CGSize(width: new_width, height: new_height)

		UIGraphicsBeginImageContextWithOptions(new_size, true, 0.0)
		self.draw(in: CGRect(x: 0, y: 0, width: new_width, height: new_height))
		let new_image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return new_image ?? UIImage()
	}
}

extension UITextField {
	func setPlaceholderColor(_ placeholderColor: UIColor) {
		attributedPlaceholder = NSAttributedString(
			string: placeholder ?? "",
			attributes: [
				.foregroundColor: placeholderColor,
				.font: font
			].compactMapValues { $0 }
		)
	}

	func addLeftPadding() {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
		self.leftView = paddingView
		self.leftViewMode = ViewMode.always
	  }
}

extension String {
	func substr(seperater: Character) -> [String] {
		var result = [String]()
		var text = ""
		var count = 0

		for char in self
		{
			if char == seperater
			{
				result.append(text)
				text = ""
				count += 1
				continue
			}

			text.append(char)
		}

		result.append(text)
		return result
	}

	func hasSpecial_characters() -> Bool {
		let special_characterSet = CharacterSet(charactersIn: "$#&*(),?'\"\\-=/:{}|[]<>")

		return self.rangeOfCharacter(from: special_characterSet) != nil
	}
}
