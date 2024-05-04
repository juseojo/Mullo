//
//  Write_post_viewController.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit
import PhotosUI

import AWSS3
import SnapKit
import RxSwift
import RxCocoa

class Write_post_viewController: UIViewController, UIScrollViewDelegate {

	var write_post_view = Write_post_view()
	var write_post_viewModel = Write_post_viewModel()
	var disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.isNavigationBarHidden = true
		self.view.backgroundColor = UIColor(named: "NATURAL")

		rx_setting()
		write_post_viewModel.add_image(image: UIImage(systemName: "plus.square")!)

		//layout
		self.view.addSubview(write_post_view)
		write_post_view.snp.makeConstraints { make in
			make.top.bottom.left.right.equalTo(self.view)
		}
	}

	func upload(image: UIImage) {

		let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)

		let configuration = AWSServiceConfiguration(region:.APNortheast2, credentialsProvider:credentialsProvider)
		AWSServiceManager.default().defaultServiceConfiguration = configuration

		let tuConf = AWSS3TransferUtilityConfiguration()
		tuConf.isAccelerateModeEnabled = false

		AWSS3TransferUtility.register(
			with: configuration!,
			transferUtilityConfiguration: tuConf,
			forKey: utilityKey
		)

		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "yyyyMMdd/"
		fileKey += dateFormat.string(from: Date())
		fileKey += String(Int64(Date().timeIntervalSince1970)) + "_"
		fileKey += UUID().uuidString + ".png"

		guard let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: utilityKey)
		else
		{
			return
		}

		let expression = AWSS3TransferUtilityUploadExpression()
		expression.setValue("public-read", forRequestHeader: "x-amz-acl")
		expression.progressBlock = { (task, progress) in
			print("progress \(progress.fractionCompleted)")
		}

		var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
		completionHandler = { (task, error) -> Void in

			print("task finished")
			let url = AWSS3.default().configuration.endpoint.url
			let publicURL = url?.appendingPathComponent(bucketName).appendingPathComponent(fileKey)
			if let absoluteString = publicURL?.absoluteString {
				print("image url : \(absoluteString)")
			}
		}
		guard let data = image.pngData() else { return }

		transferUtility.uploadData(
			data as Data,
			bucket: bucketName,
			key: fileKey,
			contentType: "image/png",
			expression: expression,
			completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
			if let error = task.error {
				print("Error: \(error.localizedDescription)")
			}

			if let _ = task.result {
				print ("upload successful.")
			}

			return nil
		}
	}

	private func posting_button_touch()
	{
		//1. image sent to image server
		do {
			for image in try write_post_viewModel.subject.value()
			{
				upload(image: image)
			}
		} catch {
			print("Error getting current images: \(error)")
		}
		//2. post inform sent to server
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
						PHPhotoLibrary.requestAuthorization { state in
							if state == .authorized {
								self.open_album()
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
