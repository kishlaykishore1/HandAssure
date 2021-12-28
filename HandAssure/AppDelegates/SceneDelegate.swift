//
//  SceneDelegate.swift
//  HandAssure
//
//  Created by kishlay kishore on 24/10/20.
//

import UIKit
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if UserDefaults.standard.string(forKey: "userName") != nil {
            isUserLogin(true)
        } else {
            isUserLogin(false)
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}
@available(iOS 13.0, *)
extension SceneDelegate {
    func isUserLogin(_ isLogin: Bool) {
        if isLogin {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.window?.rootViewController = UINavigationController(rootViewController: welcomeVC)
            self.window?.makeKeyAndVisible()
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            self.window?.rootViewController = UINavigationController(rootViewController: welcomeVC)
            self.window?.makeKeyAndVisible()
        }
    }
}

