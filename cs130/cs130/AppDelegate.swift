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
        FirebaseApp.configure()
        appUser = User(id:"204578044")
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
<<<<<<< HEAD
        
        FirebaseApp.configure()
       
        let mainTabBarController = MainTabBarController()
        
        let navigationController = UINavigationController(rootViewController: mainTabBarController)
        window?.rootViewController = navigationController
        // print("Current user: " + appUser.id) // THIS STATEMENT PREVENTS LAZY EVALUATION OF the appUser global variable
=======
        // let controller = ViewController()
//        let mainTabBarController = MainTabBarController()
        // let signUpController = SignUpController()
        // window?.rootViewController = controller
        //let courseTableViewController = CourseTableViewController()
        //let navigationController = UINavigationController(rootViewController: courseTableViewController)
        //window?.rootViewController = DemoController()
        window?.rootViewController = PostViewController()
>>>>>>> backendbois
        return true
    }
}

