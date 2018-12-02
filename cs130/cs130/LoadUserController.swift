//
//  LoadUserController.swift
//  cs130
//
//  Created by Jesse Chen on 11/29/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

/// This view controller is a loading page
class LoadUserController: UIViewController {
    static var singletonUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.storeCredentials()
        self.setUpName()
    }


    // stores current user information into singletonUser:User object
    private func storeCredentials() {
        if((Auth.auth().currentUser?.uid) != nil) {
            let userID : String = (Auth.auth().currentUser?.uid)!
            print("Current user is: ", userID)
            
            let ref = Database.database().reference().child("users").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                LoadUserController.singletonUser = User(uid: userID, dictionary: dictionary, luc:self)
            }
        } else {
            print("Error, couldn't get user credentails")
        }
    }

    /// Transitions the NavigationController to the PersonalBoardController
    /// is called when singletonUser is done fetching data from database
    func transitionToBoard() {
        let personalBoardController = PersonalBoardController()
        let navController = UINavigationController(rootViewController:personalBoardController)
        self.present(navController, animated:true, completion:nil)
    }


    let name: UILabel = {
        let label = UILabel();
        label.text = "Loading..."
        label.textColor = UIColor.black
        label.isEnabled = true
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    /// displays "Loading..." on the screen while user information is being fetched from database
    fileprivate func setUpName() {
        view.addSubview(name)
        name.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: -12, top: view.topAnchor, topPadding: 120, bottom: nil, bottomPadding: 0, width: 0, height: 50)
    }


}
