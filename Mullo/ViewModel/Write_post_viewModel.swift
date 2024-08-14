//
//  Write_post_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 4/29/24.
//

import UIKit

import Alamofire
import AWSS3
import RxSwift
import SnapKit

final class Write_post_viewModel
{
	private let disposeBag = DisposeBag()
	let subject = BehaviorSubject<[UIImage]>(value: [])
	var items: Observable<[UIImage]> {
		return subject.compactMap { $0 }
	}

	func add_image(image: UIImage)
	{
		do {
			var current_images = try subject.value()
			if current_images.count == 0 {
				current_images.insert(image, at: 0)
			}
			else {
				current_images.insert(image, at: current_images.count - 1)
			}
			subject.onNext(current_images)
		} catch {
			print("Error getting current images: \(error)")
		}
	}

	func send_post(parameters: [String: String], complete_handler: @escaping (Bool) -> Void)
	{
		AF.request(
			"https://\(host)/new_post",
			method: .post,
			parameters: parameters,
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String: String].self) { response in
			switch response.result {
			case .success:
				print("posting success")
				complete_handler(true)
			case .failure(let error):
				print("Error: \(error)")
				complete_handler(false)
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
		}
	}

	func upload_image(image: UIImage) async throws -> String {

		let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)

		let configuration = AWSServiceConfiguration(region:.APNortheast2, credentialsProvider:credentialsProvider)
		AWSServiceManager.default().defaultServiceConfiguration = configuration

		let transfer_configure = AWSS3TransferUtilityConfiguration()
		transfer_configure.isAccelerateModeEnabled = false

		try await AWSS3TransferUtility.register(
			with: configuration!,
			transferUtilityConfiguration: transfer_configure,
			forKey: utilityKey
		)

		let dateFormat = DateFormatter()
		dateFormat.dateFormat = "yyyyMMdd/"
		var file_path = fileKey
		file_path += dateFormat.string(from: Date())
		file_path += String(Int64(Date().timeIntervalSince1970)) + "_"
		file_path += UUID().uuidString + ".png"

		guard let transferUtility =
				AWSS3TransferUtility.s3TransferUtility(forKey: utilityKey) else { return ""}

		let expression = AWSS3TransferUtilityUploadExpression()
		expression.setValue("public-read", forRequestHeader: "x-amz-acl")

		guard let data = image.pngData() else { return ""}

		var result = ""
		transferUtility.uploadData(
			data as Data,
			bucket: bucketName,
			key: file_path,
			contentType: "image/png",
			expression: expression).continueWith { (task) -> AnyObject? in

			if let error = task.error {
				print("Error: \(error.localizedDescription)")
				AlertHelper.showAlert(
					title: "오류", message: "서버 오류입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}

			if task.result != nil
			{
				print ("upload successful.")
				let url = AWSS3.default().configuration.endpoint.url
				let publicURL = url?.appendingPathComponent(bucketName).appendingPathComponent(file_path)
				result = publicURL?.absoluteString ?? ""
				print("image url : \(result)")
			}

			return nil
		}
		return result
	}
}
