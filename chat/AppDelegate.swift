//
//  AppDelegate.swift
//  chat
//
//  Created by Fraol on 1/14/20.
//  Copyright © 2020 Fraol. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        //Create a window that is the same size as the screen
         window = UIWindow(frame: UIScreen.main.bounds)
         window?.makeKeyAndVisible()

         // Create a view controller
         //let RootviewController = SignedInViewController()
         // Assign the view controller as `window`'s root view controller
        //window?.rootViewController = RootviewController
         // Show the window
        //window?.removeFromSuperview()
        
        // Override point for customization after application launch.
        
        return true
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

