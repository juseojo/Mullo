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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

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

	final func register_name(name: String, email: String) -> Observable<String>
	{
		return Observable.create { observer in

			AF.request(
				"https://\(host)/register",
				method: .post, parameters: ["name" : name, "email" : email],
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

	final func google_login(vc: Welcome_viewController) -> Observable<Bool>
	{
		return Observable.create { observer in

			guard let clientID = FirebaseApp.app()?.options.clientID
			else
			{
				print("Firebase clientID not found.")
				observer.onNext(false)

				return Disposables.create()
			}

			// Create Google Sign In configuration object.
			let config = GIDConfiguration(clientID: clientID)
			GIDSignIn.sharedInstance.configuration = config

			// Start the sign in flow!
			GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in

				guard error == nil, let result = result else {
					print("---Google Sign-In fail---\n\(error?.localizedDescription ?? "Unknown error")")
					observer.onNext(false)

					return
				}

				guard let idToken = result.user.idToken?.tokenString else {
					print("---Google Sign-In token retrieval fail---")
					observer.onNext(false)

					return
				}

				let accessToken = result.user.accessToken.tokenString

				let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

				// Do google login
				Auth.auth().signIn(with: credential) { result, error in
					// At this point, our user is signed in
					if let error = error {
						print("---Google Sign-In authentication fail---\n\(error.localizedDescription)")
						observer.onNext(false)

						return
					}

					print("google signin success")
					vc.email_address = result?.user.email ?? ""
					print("user email : \(vc.email_address)")
					observer.onNext(true)
				}
			}

			return Disposables.create()
		}
	}

	final func kakao_login()
	{
		if (UserApi.isKakaoTalkLoginAvailable()) {
			UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
				if let error = error {
					print(error)
				}
				else {
					print("loginWithKakaoTalk() success.")

					//do something
					_ = oauthToken
				}
			}
		}
	}
}
