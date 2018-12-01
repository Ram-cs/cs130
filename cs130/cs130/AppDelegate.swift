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
        FirebaseApp.configure()
        
        // Override point for customization after application launch.
        //appUser = User(id:"204578044")
        let samplePost:Post = Post(creator: "204578044",
                                            title: "piggyboie",
                                            content: "pig1 post text post post textexample post post post post post post post po stpo stpos tpos tpost post post postpost pos tpos tpos tpos top stpo stop stpo stpo stpo st textexample comment text",
                                            major: "Mechanical Engineering",
                                            course: "101",
                                            isTutorSearch: false)
        //let dac = DatabaseAddController()
        //dac.addPost(post:samplePost)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
       
        let mainTabBarController = MainTabBarController()
        
        // let navigationController = UINavigationController(rootViewController: mainTabBarController)
        let navigationController = UINavigationController(rootViewController: LoginController())
        //window?.rootViewController = ReplyController(rootPost: samplePost)
        //window?.rootViewController = PostController(rootPost: samplePost)
        window?.rootViewController = navigationController
        // print("Current user: " + appUser.id) // THIS STATEMENT PREVENTS LAZY EVALUATION OF the appUser global variable
        return true
    }
}
