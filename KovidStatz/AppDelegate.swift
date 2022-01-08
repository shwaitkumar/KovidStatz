//
//  AppDelegate.swift
//  KovidStatz
//
//  Created by Shwait Kumar on 08/01/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window?.overrideUserInterfaceStyle = .light
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        pushToHomeScreenViewController()
        
        return true
    }
    
    func pushToHomeScreenViewController() -> Void {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreenViewController") as! HomeScreenViewController
        let nc = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }

}

