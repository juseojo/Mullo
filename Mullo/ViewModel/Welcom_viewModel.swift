//
//  Welcom_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 5/14/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import Alamofire

final class Welcome_viewModel {

	final func register(email: String, password: String, result_handler: @escaping (Bool) -> Void)
	{
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if authResult == nil
			{
				print("---regist fail---\n\(error.debugDescription)")
				result_handler(false)
			}
			else
			{
				print("regist success")
				result_handler(true)
			}
		}
	}

	final func login(email: String, password: String, result_handler: @escaping (Bool) -> Void)
	{
		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
			guard error == nil else 
			{
				print(error)	
				result_handler(false)

				return
			}

			if authResult == nil
			{
				print("---login fail---\n\(error.debugDescription)")
				result_handler(false)
			}
			else
			{
				print("login success")
				result_handler(true)
			}
		}
	}

	final func register_name(name: String, result_handler: @escaping (String) -> Void)
	{
		AF.request(
			"http://\(host)/register",
			method: .post, parameters: ["name" : name],
			encoding: URLEncoding.httpBody)
				.validate(statusCode: 200..<300)
				.validate(contentType: ["application/json"])
				.responseDecodable(of: [String:String].self) { response in
			switch response.result {
			case .success:
				do {
					let data = try response.result.get()

					result_handler(data["result"] ?? "error")
				} catch {
					print("-- Error at getting current images --\n \(error)")
					result_handler("error")
				}
			case .failure(let error):
				print("Error: \(error)")
				result_handler("error")
			}
		}
	}

	final func google_login(vc: Welcome_viewController)
	{
		guard let clientID = FirebaseApp.app()?.options.clientID 
		else 
		{
			print("Firebase clientID not found.")

			return
		}

		// Create Google Sign In configuration object.
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.configuration = config

		// Start the sign in flow!
		GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in

			guard error == nil, let result = result else {
				print("---Google Sign-In fail---\n\(error?.localizedDescription ?? "Unknown error")")
				return
			}

			guard let idToken = result.user.idToken?.tokenString else {
				print("---Google Sign-In token retrieval fail---")
				return
			}

			let accessToken = result.user.accessToken.tokenString

			let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

			Auth.auth().signIn(with: credential) { result, error in
				// At this point, our user is signed in
				if let error = error {
					print("---Google Sign-In authentication fail---\n\(error.localizedDescription)")
					return
				}

				print("signin success")

				// Case of didn't set name
				if UserDefaults.standard.string(forKey: "name") == nil
				{
					// Change view ( current view -> name view )
					vc.welcome_view.register_view.removeFromSuperview()
					vc.welcome_view.login_view.removeFromSuperview()

					vc.welcome_view.name_view.snp.makeConstraints { make in
						make.top.equalTo(vc.welcome_view.welcome_label.snp.bottom).offset(50)
						make.left.right.equalTo(vc.welcome_view)
						make.height.equalTo(100)
					}
					
					if vc.welcome_view.login_button.superview != nil
					{
						vc.welcome_view.login_button.snp.remakeConstraints { make in
							make.top.equalTo(vc.welcome_view.name_view.snp.bottom)
							make.left.right.equalTo(vc.welcome_view).inset(30)
							make.height.equalTo(55)
						}
					}
					else
					{
						vc.welcome_view.register_button.snp.remakeConstraints { make in
							make.top.equalTo(vc.welcome_view.name_view.snp.bottom)
							make.left.right.equalTo(vc.welcome_view).inset(30)
							make.height.equalTo(55)
						}
					}
				}
				else
				{
					// Change VC ( current VC -> Main VC )
					let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
					guard let delegate = sceneDelegate else {
						print("sceneDelegate delegate error")
						return
					}
					delegate.changeRootVC(Main_ViewController(), animated: true)
				}
			}
		}
	}
}
