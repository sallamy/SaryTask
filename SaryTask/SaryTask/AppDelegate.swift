//
//  AppDelegate.swift
//  SaryTask
//
//  Created by concarsadmin on 5/1/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.isHidden = false
        setRootViewController()
        return true
    }
    
    func setRootViewController() {
        self.window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
    }

}

