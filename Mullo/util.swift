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

class AlertHelper {
	static func showAlert(
		title: String, message: String, button_title: String, handler: ((UIAlertAction) -> Void)?) 
	{
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
				  let window = windowScene.windows.first(where: { $0.isKeyWindow }),
				  var top_viewController = window.rootViewController else {
			return
		}

		while let presented_viewController = top_viewController.presentedViewController {
			top_viewController = presented_viewController
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: button_title, style: .default, handler: handler))

		top_viewController.present(alert, animated: true, completion: nil)
	}

	static func showAlert(alert: UIAlertController)
	{
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
				  let window = windowScene.windows.first(where: { $0.isKeyWindow }),
				  var top_viewController = window.rootViewController else {
			return
		}

		while let presented_viewController = top_viewController.presentedViewController {
			top_viewController = presented_viewController
		}

		top_viewController.present(alert, animated: true, completion: nil)
	}
	static func showAlert(
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
}

func calculate_height(text: String, font: UIFont, width: CGFloat) -> CGFloat
{
	let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))

	label.font = font
	label.numberOfLines = 0
	label.text = text
	label.sizeToFit()

	return label.frame.height
}

func time_diff(past_date: String) -> String
{
	let date_formatter = DateFormatter()

	date_formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	date_formatter.locale = Locale(identifier: "ko_KR")
	date_formatter.timeZone = TimeZone(abbreviation: "KST")

	let post_time = date_formatter.date(from: past_date)
	let now_date = Date()
	let diff = Int(now_date.timeIntervalSince(post_time!))/60
	var result_str = ""

	switch diff
	{
	case ...1:
		result_str = "몇초 전"
	case ...60:
		result_str = "\(diff)분 전"
	case ...3600:
		result_str = "\(diff/60)시간 전"
	default:
		result_str = "\(diff/3600)일 전"
	}

	return result_str
}

func get_time_now() -> String
{
	let date = Date()
	let dateFormatter = DateFormatter()
	
	dateFormatter.locale = Locale(identifier: "ko_KR")
	dateFormatter.timeZone = TimeZone(abbreviation: "KST")
	dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

	return dateFormatter.string(from: date)
}

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
			AlertHelper.showAlert(viewController: vc,
					   title: "알림",
					   message: "서버 점검중입니다.",
					   button_title: "확인",
					   handler: { _ in isServer_ok(vc: vc) })
		}
	}
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
