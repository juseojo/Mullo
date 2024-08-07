//
//  AppDelegate.swift
//  Mullo
//
//  Created by seongjun cho on 4/15/24.
//

import UIKit

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import RxKakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		RxKakaoSDK.initSDK(appKey: kakao_native_app_key)

		return true
	}

	func application(_ app: UIApplication, open url: URL,  options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
		//for google login

		if AuthApi.isKakaoTalkLoginUrl(url) {
			return AuthController.rx.handleOpenUrl(url: url)
		}

		if GIDSignIn.sharedInstance.handle(url) {
			return true
		}

		return false
	}
	// MARK: UISceneSession Lifecycle


	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

