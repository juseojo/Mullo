//
//  util.swift
//  Mullo
//
//  Created by seongjun cho on 4/16/24.
//

import UIKit
import RxSwift
import Alamofire

let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
let head_height: CGFloat = screen_height * 0.05
let top_inset = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0

func isServer_ok(vc: UIViewController)
{
	AF.request(
		"https://\(host)/server_check",
		method: .post,
		encoding: URLEncoding.httpBody)
	.validate(statusCode: 200..<300)
	.validate(contentType: ["application/json"])
	.responseDecodable(of: [String:String].self) { response in
		switch response.result {
		case .success:
			return
		case .failure(let error):
			print("Error: \(error)")
			show_alert(viewController: vc,
					   title: "알림",
					   message: "서버 점검중입니다.",
					   button_title: "확인",
					   handler: { _ in isServer_ok(vc: vc) })
		}
	}
}

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

extension UIImage {
	func resized(to size: CGSize) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
