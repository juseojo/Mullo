//
//  Welcom_viewModel.swift
//  Mullo
//
//  Created by seongjun cho on 5/14/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth

final class Welcome_viewModel {

	final func register(email: String, password: String)
	{
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			if authResult == nil
			{
				print("---regist fail---\n\(error.debugDescription)")
			}
			else
			{
				print("regist success")
			}
		}
	}

	final func login(vc: UIViewController , email: String, password: String)
	{
		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

			if authResult == nil
			{
				print("---login fail---\n\(error.debugDescription)")
				show_alert(viewController: vc, title: "로그인", message: "로그인에 실패하였습니다.\n아이디와 비밀번호를 다시 확인해주세요.", button_title: "확인", handler: {_ in})
			}
			else
			{
				print("login success")
				let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
				guard let delegate = sceneDelegate else {
					print("login delegate error")
					return
				}
				delegate.changeRootVC(Main_ViewController(), animated: true)
			}
		}
	}
}
