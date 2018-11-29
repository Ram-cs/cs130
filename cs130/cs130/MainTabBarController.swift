//
//  MainTabBarController.swift
//  cs130
//
//  Created by Ram Yadav on 11/9/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        DispatchQueue.main.async { //must put in dispatchque because of thead
            if Auth.auth().currentUser == nil {
                let logInController = LoginController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
            }
            
       // }
        
//        // window?.rootViewController = controller
//        let courseTableViewController = CourseTableViewController()
//        let userProfileController = UserProfileController()
        
        let personalBoardController = PersonalBoardController()
        let navController = UINavigationController(rootViewController: personalBoardController)
        self.present(navController, animated: true, completion: nil)
    }
}
