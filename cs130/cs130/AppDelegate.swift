//
//  AppDelegate.swift
//  cs130
//
//  Created by Ram Yadav on 11/2/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//
import UIKit
import Firebase
// This global variable is the currently logged-in user
// var appUser = User(id: "TESTUSER", major: "Computer Science")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appUser:User!
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //appUser = User(id:"204578044")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
       
        let mainTabBarController = MainTabBarController()
        
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        window?.rootViewController = ReplyController()
        // print("Current user: " + appUser.id) // THIS STATEMENT PREVENTS LAZY EVALUATION OF the appUser global variable
        return true
    }
}
