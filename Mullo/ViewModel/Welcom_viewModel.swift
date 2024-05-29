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

	final func register_name(name: String, email: String, result_handler: @escaping (String) -> Void)
	{
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

					result_handler(data["result"] ?? "|error")
				} catch {
					print("-- Error at register_name --\n \(error)")
					result_handler("|error")
				}
			case .failure(let error):
				print("Error: \(error)")
				result_handler("|error")
			}
		}
	}

	final func get_name(email: String, result_handler: @escaping (String) -> Void)
	{
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

					result_handler(data["result"] ?? "|error")
				} catch {
					print("-- Error at get_name --\n \(error)")
					result_handler("|error")
				}
			case .failure(let error):
				print("Error: \(error)")
				result_handler("|error")
			}
		}
	}

	final func google_login(vc: Welcome_viewController, result_handler: @escaping (Bool) -> Void)
	{
		guard let clientID = FirebaseApp.app()?.options.clientID 
		else 
		{
			print("Firebase clientID not found.")
			result_handler(false)

			return
		}

		// Create Google Sign In configuration object.
		let config = GIDConfiguration(clientID: clientID)
		GIDSignIn.sharedInstance.configuration = config

		// Start the sign in flow!
		GIDSignIn.sharedInstance.signIn(withPresenting: vc) { result, error in

			guard error == nil, let result = result else {
				print("---Google Sign-In fail---\n\(error?.localizedDescription ?? "Unknown error")")
				result_handler(false)

				return
			}

			guard let idToken = result.user.idToken?.tokenString else {
				print("---Google Sign-In token retrieval fail---")
				result_handler(false)

				return
			}

			let accessToken = result.user.accessToken.tokenString

			let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

			// Do google login
			Auth.auth().signIn(with: credential) { result, error in
				// At this point, our user is signed in
				if let error = error {
					print("---Google Sign-In authentication fail---\n\(error.localizedDescription)")
					result_handler(false)

					return
				}

				print("google signin success")
				vc.email_address = result?.user.email ?? ""
				result_handler(true)
			}
		}
	}
}
