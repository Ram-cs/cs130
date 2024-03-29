//
//  MainTabBarController.swift
//  cs130
//
//  Created by Ram Yadav on 11/9/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//
//reference: https://www.letsbuildthatapp.com/course/Instagram-Firebase
import UIKit
import Firebase

/// This view controller decides whether a user is logged in and redirects to either login page or loading page
class MainTabBarController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        //User don't have to enter email and password each time when logged it unless he signed up
            if Auth.auth().currentUser == nil {
                let logInController = LoginController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
            }
        
        
//        // window?.rootViewController = controller
//        let courseTableViewController = CourseTableViewController()
//        let userProfileController = UserProfileController()

        //go to LoadUserController

        let loadUserController = LoadUserController()
        let navController = UINavigationController(rootViewController: loadUserController)
        self.present(navController, animated: true, completion: nil)
    }
}
