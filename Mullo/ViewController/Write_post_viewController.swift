//
//  Write_post_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit
import PhotosUI

import AWSS3
import Alamofire
import SnapKit
import RxSwift
import RxCocoa

final class Write_post_viewController: UIViewController, UIScrollViewDelegate {

	var write_post_view = Write_post_view()
	var write_post_viewModel = Write_post_viewModel()
	var disposeBag = DisposeBag()
	var keyboard_height = 0
	var active_textField: UITextField?

	override func viewWillAppear(_ animated: Bool) {
		// For get keyboard height
		NotificationCenter.default.addObserver(
			self, selector: #selector(keyboard_up), name: UIResponder.keyboardWillShowNotification, object: nil)
		// it will removed at keyboard_up
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Up the keyboard for get keyboard height
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			self.write_post_view.post_text_view.becomeFirstResponder()
		}

		// keyboard down setting
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss_keyboard))
		tapGesture.cancelsTouchesInView = false
		view.addGestureRecognizer(tapGesture)

		// UITextFieldDelegate 및 UITextViewDelegate 설정
		self.write_post_view.first_choice_textField.delegate = self
		self.write_post_view.second_choice_textField.delegate = self
		self.write_post_view.third_choice_textField.delegate = self
		self.write_post_view.fourth_choice_textField.delegate = self

		// basic setting
		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		// rx setting
		rx_setting()

		// first image set
		write_post_viewModel.add_image(image: UIImage(systemName: "plus.square")!)

		// layout
		self.view.addSubview(write_post_view)
		write_post_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}
	}

	// When up the keyboard, save height and close that
	@objc func keyboard_up(notification:NSNotification) {
		if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			// save keyboard height
			keyboard_height = Int(keyboardFrame.cgRectValue.height)
			// keyboard down
			self.write_post_view.post_text_view.resignFirstResponder()
			// For don't work anymore
			NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		}
	}

	@objc func dismiss_keyboard() {
		view.endEditing(true)
	}

	private func posting_button_touch()
	{
		//0.exception
		if self.write_post_view.post_text_view.text.isEmpty
		{
			show_alert(viewController: self, title: "알림", message: "내용이 비어있습니다.", button_title: "확인", handler: nil)
			return
		}
		else if self.write_post_view.first_choice_textField.hasText == false
		{
			show_alert(viewController: self, title: "알림", message: "첫번째 선택지가 비어있습니다.", button_title: "확인", handler: nil)
			return
		}
		else if self.write_post_view.second_choice_textField.hasText == false
		{
			show_alert(viewController: self, title: "알림", message: "두번째 선택지가 비어있습니다.", button_title: "확인", handler: nil)
			return
		}
		else if (self.write_post_view.third_choice_textField.superview != nil) &&
					(self.write_post_view.third_choice_textField.hasText == false)
		{
			show_alert(viewController: self, title: "알림", message: "세번째 선택지가 비어있습니다.", button_title: "확인", handler: nil)
			return
		}
		else if (self.write_post_view.fourth_choice_textField.superview != nil) &&
					(self.write_post_view.fourth_choice_textField.hasText == false)
		{
			show_alert(viewController: self, title: "알림", message: "네번째 선택지가 비어있습니다.", button_title: "확인", handler: nil)
			return
		}

		Task {
			//1. image send to image server
			var images_url = ""
			var images = try write_post_viewModel.subject.value()
			images.removeLast()
			for image in images
			{
				if image.pngData()?.count ?? 0 > 1000000
				{
					let new_image = image.resize(ratio: 1000000.0 / Float(image.pngData()!.count))
					images_url += try await self.write_post_viewModel.upload_image(image: new_image) + "|"
				}
				else
				{
					images_url += try await self.write_post_viewModel.upload_image(image: image) + "|"
				}
			}
			if images_url.isEmpty == false
			{
				images_url.removeLast()
			}
			print("parameter setting")
			var choice_text = ""
			choice_text += (self.write_post_view.first_choice_textField.text ?? "") + "|"
			choice_text += (self.write_post_view.second_choice_textField.text ?? "")
			if self.write_post_view.third_choice_textField.hasText
			{
				choice_text += "|" + self.write_post_view.third_choice_textField.text!
			}

			if self.write_post_view.fourth_choice_textField.hasText
			{
				choice_text += "|" + self.write_post_view.fourth_choice_textField.text!
			}

			//2. post inform sent to server
			var choice_count = "0"
			for _ in 1...choice_text.filter({$0 == "|" as Character}).count
			{
				choice_count += "|0"
			}
			let parameters: [String: String] = [
				"name": UserDefaults.standard.string(forKey: "name") ?? "None",
				"time": get_time_now(),
				"post": self.write_post_view.post_text_view.text,
				"choice": choice_text,
				"choice_count": choice_count,
				"pictures": images_url
			]

			print("parameters : \(parameters)")
			self.write_post_viewModel.send_post(parameters: parameters) { isSuccess in
				if isSuccess
				{
					self.navigationController?.popViewController(animated:true)
				}
			}
		}
	}

	private func back_button_touch()
	{
		self.navigationController?.popViewController(animated:true)
	}

	private func choice_plus_button_touch()
	{
		if self.write_post_view.third_choice_textField.superview == nil
		{
			self.write_post_view.add_third_choice_textField()
		}
		else if self.write_post_view.fourth_choice_textField.superview == nil
		{
			self.write_post_view.add_fourth_choice_textField()
		}
		else
		{
			let alert = UIAlertController(title: "알림", message: "선택지는 최대 4개입니다.", preferredStyle: .alert)
			let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)

			alert.addAction(confirm)
			present(alert, animated: true)
		}
	}

	private func choice_minus_button_touch()
	{

		if self.write_post_view.third_choice_textField.superview == nil
		{
			let alert = UIAlertController(title: "알림", message: "선택지는 최소 2개입니다.", preferredStyle: .alert)
			let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)

			alert.addAction(confirm)
			present(alert, animated: true)
		}
		else if self.write_post_view.fourth_choice_textField.superview == nil
		{
			self.write_post_view.delete_textField(target: self.write_post_view.third_choice_textField)
		}
		else
		{
			self.write_post_view.delete_textField(target: self.write_post_view.fourth_choice_textField)
		}
	}

	private func rx_setting()
	{
		//delegate
		write_post_view.image_collectionView.rx.setDelegate(self)
			.disposed(by: disposeBag)

		//button touch event
		write_post_view.back_button.rx.tap
			.bind{
				self.back_button_touch()
			}.disposed(by: disposeBag)

		write_post_view.choice_plus_button.rx.tap
			.bind{
				self.choice_plus_button_touch()
			}.disposed(by: disposeBag)
		write_post_view.choice_minus_button.rx.tap
			.bind{
				self.choice_minus_button_touch()
			}.disposed(by: disposeBag)
		write_post_view.posting_button.rx.tap
			.bind{
				self.posting_button_touch()
			}.disposed(by: disposeBag)

		//binding
		write_post_viewModel.items
			.observe(on: MainScheduler.instance)
			.bind(to:write_post_view.image_collectionView.rx.items(
				cellIdentifier: Image_collectionView_cell.identifier, cellType: Image_collectionView_cell.self))
			{ row, item, cell in
				cell.image_view.image = item
			}.disposed(by: self.disposeBag)

		//image select event
		write_post_view.image_collectionView.rx.itemSelected
			.subscribe{ indexPath in
				if indexPath.row + 1 == self.write_post_view.image_collectionView.numberOfItems(inSection: 0)
				{	//append image
					switch PHPhotoLibrary.authorizationStatus() {
					case .authorized:
						print("User album: pass")
						self.open_album()
					case .denied:
						print("User album: denied")
						UIApplication.shared.open(	
							URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
					case .notDetermined:
						print("User album: notDetermined")
						PHPhotoLibrary.requestAuthorization(for: .readWrite) { state in
							if state == .authorized {
								DispatchQueue.main.async {
									self.open_album()
								}
							} else {
								self.dismiss(animated: true, completion: nil)
							}
						}
					default:
						break
					}
				}
			}.disposed(by: disposeBag)
	}

	private func open_album() {
		var configuration = PHPickerConfiguration()

		configuration.selectionLimit = 1
		configuration.filter = .images

		let picker_vc = PHPickerViewController(configuration: configuration)

		picker_vc.delegate = self
		self.present(picker_vc, animated: true)
	}
}

extension Write_post_viewController : PHPickerViewControllerDelegate {

	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		//choose image in album
		picker.dismiss(animated: true, completion: nil)

		guard let provider = results.first?.itemProvider else { return }
		if provider.canLoadObject(ofClass: UIImage.self) {
			provider.loadObject(ofClass: UIImage.self) { image, error in
				DispatchQueue.main.async { //
					guard let selectedImage = image as? UIImage else { return }
					self.write_post_viewModel.add_image(image: selectedImage)
				}
			}
		}
	}
}

extension Write_post_viewController: UITextFieldDelegate {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			self.view.endEditing(true)
		}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

		active_textField = textField

		self.write_post_view.posting_button.snp.updateConstraints{ (make) in
			make.top.equalTo(self.write_post_view.choice_plus_button.snp.bottom).inset(-50 - keyboard_height)
		}

		UIView.animate(
			withDuration: 0.2,
			animations: self.write_post_view.layoutIfNeeded)

		self.write_post_view.scroll_to_bottom()

		return true
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

		if textField != active_textField {
			return true
		}

		self.write_post_view.posting_button.snp.updateConstraints{ (make) in
			make.top.equalTo(self.write_post_view.choice_plus_button.snp.bottom).inset(-50)
		}

		UIView.animate(
			withDuration: 0.2,
			animations: self.write_post_view.layoutIfNeeded)

		return true
	}
}
