//
//  Welcom_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 5/14/24.
//

import UIKit
import RxSwift

import Alamofire
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import AuthenticationServices

final class Welcome_viewModel {

	private let disposeBag = DisposeBag()

	final func register(email: String, password: String) -> Observable<Bool>
	{
		return Observable.create { observer in
			Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
				if let error = error {
					print("---register fail---\n\(error.localizedDescription)")
					observer.onNext(false)
				} else {
					print("register success")
					observer.onNext(true)
				}
			}

			return Disposables.create()
		}
	}

	final func login(email: String, password: String) -> Observable<Bool>
	{
		return Observable.create { observer in
			Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
				guard error == nil else
				{
					print(error)
					observer.onNext(false)

					return
				}

				if authResult == nil
				{
					print("---login fail---\n\(error.debugDescription)")
					observer.onNext(false)
				}
				else
				{
					print("login success")
					observer.onNext(true)
				}
			}

			return Disposables.create()
		}
	}

	final func register_name(name: String, email: String, identifier: String, auth_code: String) -> Observable<String>
	{
		return Observable.create { observer in

			AF.request(
				"https://\(host)/register",
				method: .post,
				parameters: ["name" : name, "email" : email, "identifier" : identifier, "auth_code" : auth_code],
				encoding: URLEncoding.httpBody)
			.validate(statusCode: 200..<300)
			.validate(contentType: ["application/json"])
			.responseDecodable(of: [String:String].self) { response in
				switch response.result {
				case .success:
					do {
						let data = try response.result.get()

						observer.onNext(data["result"] ?? "|error")
					} catch {
						print("-- Error at register_name --\n \(error)")
						observer.onNext("|error")
					}
				case .failure(let error):
					print("Error: \(error)")
					observer.onNext("|error")
				}
			}

			return Disposables.create()
		}
	}

	final func find_password(email: String)
	{
		Auth.auth().sendPasswordReset(withEmail: email) { error in
			if error != nil {
				AlertHelper.showAlert(
					title: "오류", message: "Firebase mail 오류 입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
			}
			else {
				AlertHelper.showAlert(
					title: "알림", message: "위 이메일로 비밀번호 재설정 메일을 보냈습니다.", button_title: "확인", handler: nil)
			}
		}
	}

	final func change_name(name: String, identifier: String, result_handler: @escaping (String) -> ())
	{
		AF.request(
			"https://\(host)/change_name",
			method: .post, parameters: ["name" : name, "identifier": identifier],
			encoding: URLEncoding.httpBody)
		.validate(statusCode: 200..<300)
		.validate(contentType: ["application/json"])
		.responseDecodable(of: [String:String].self) { response in
			switch response.result {
			case .success:
				do {
					let data = try response.result.get()

					if data["result"] == "success" {
						result_handler("success")
					}
					else if data["result"] == "overlap_name" {
						result_handler("overlap_name")
					}
					else {
						result_handler("error")
					}
				} catch {
					print("-- Error at change_name --\n \(error)")
					result_handler("error")
				}
			case .failure(let error):
				print("Error: \(error)")
				result_handler("error")
			}
		}
	}

	final func hasName(identifier: String) -> Observable<String>
	{
		return Observable.create { observer in

			AF.request(
				"https://\(host)/hasName",
				method: .post, parameters: ["identifier" : identifier],
				encoding: URLEncoding.httpBody)
			.validate(statusCode: 200..<300)
			.validate(contentType: ["application/json"])
			.responseDecodable(of: [String:String].self) { response in
				switch response.result {
				case .success:
					do {
						let data = try response.result.get()

						if data["result"] == "false" {
							observer.onNext("false")
						}
						else if data["result"] == "null" {
							observer.onNext("null")
						}
						else {
							observer.onNext(data["result"] ?? "None")
						}
					} catch {
						print("-- Error at get_name --\n \(error)")
						observer.onNext("null")
					}
				case .failure(let error):
					print("Error: \(error)")
					observer.onNext("null")
				}
			}

			return Disposables.create()
		}
	}

	final func get_name(email: String) -> Observable<String>
	{
		return Observable.create { observer in

			AF.request(
				"https://\(host)/get_name",
				method: .post, parameters: ["email" : email],
				encoding: URLEncoding.httpBody)
			.validate(statusCode: 200..<300)
			.validate(contentType: ["application/json"])
			.responseDecodable(of: [String:String].self) { response in
				switch response.result {
				case .success:
					do {
						let data = try response.result.get()

						observer.onNext(data["result"] ?? "|error")
					} catch {
						print("-- Error at get_name --\n \(error)")
						observer.onNext("|error")
					}
				case .failure(let error):
					print("Error: \(error)")
					observer.onNext("|error")
				}
			}

			return Disposables.create()
		}
	}

	final func google_login(vc: Welcome_viewController) -> Observable<String>
	{
		return Observable.create { observer in

			guard let clientID = FirebaseApp.app()?.options.clientID
			else
			{
				print("Firebase clientID not found.")
				AlertHelper.showAlert(
					title: "오류", message: "Firebase 오류 입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
				observer.onNext("")

				return Disposables.create()
			}

			// Create Google Sign In configuration object.
			let config = GIDConfiguration(clientID: clientID)
			GIDSignIn.sharedInstance.configuration = config

			// Start the sign in flow!
			GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in

				guard error == nil, let result = result else {
					print("---Google Sign-In fail---\n\(error?.localizedDescription ?? "Unknown error")")
					observer.onNext("")
					AlertHelper.showAlert(
						title: "오류", message: "구글 로그인 실패입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)

					return
				}

				guard let idToken = result.user.idToken?.tokenString else {
					print("---Google Sign-In token retrieval fail---")
					AlertHelper.showAlert(
						title: "오류", message: "구글 로그인 실패입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
					observer.onNext("")

					return
				}

				let accessToken = result.user.accessToken.tokenString

				let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

				// Do google login
				Auth.auth().signIn(with: credential) { result, error in
					// At this point, our user is signed in
					if let error = error {
						print("---Google Sign-In authentication fail---\n\(error.localizedDescription)")
						observer.onNext("")
						AlertHelper.showAlert(
							title: "오류", message: "구글 인증 실패입니다. 다시 시도해주세요.", button_title: "확인", handler: nil)
						return
					}
					print("google signin success")
					observer.onNext(result?.user.email ?? "")
				}
			}

			return Disposables.create()
		}
	}

	final func kakao_login() -> Observable<String>
	{
		return Observable.create { [weak self] observer in

			if (UserApi.isKakaoTalkLoginAvailable()) {
				UserApi.shared.rx.loginWithKakaoTalk()
					.subscribe(onNext:{ (oauthToken) in
						print("loginWithKakaoTalk() success.")

						UserApi.shared.rx.me()
							.subscribe (onSuccess:{ user in
								observer.onNext(user.kakaoAccount?.email ?? "")
								observer.onCompleted()
								_ = user
							}, onFailure: {error in
								print(error)
							})
							.disposed(by: self!.disposeBag)

						_ = oauthToken
					}, onError: {error in
						print(error)
						observer.onError(error)
					}).disposed(by: self!.disposeBag)
			}
			else
			{
				print("loginWithKakaoTalk() fail.")
			}
			return Disposables.create()
		}
	}

	final func apple_login(vc: Welcome_viewController)
	{
		let request = ASAuthorizationAppleIDProvider().createRequest()
		request.requestedScopes = [.email]

		let controller = ASAuthorizationController(authorizationRequests: [request])
		controller.delegate = vc as? ASAuthorizationControllerDelegate
		controller.presentationContextProvider = vc as? ASAuthorizationControllerPresentationContextProviding
		controller.performRequests()
	}
}
