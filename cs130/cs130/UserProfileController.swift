//
//  UserProfileController.swift
//  cs130
//
//  Created by Ram Yadav on 11/23/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

import Firebase

class UserProfileController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUplogOutButton()
        
        showUserCredentials()
        
    }
    
    private func showUserCredentials() {
        
        if((Auth.auth().currentUser?.uid) != nil) {
            let userID : String = (Auth.auth().currentUser?.uid)!
            print("Current user is: ", userID)
            
            let ref = Database.database().reference().child("accountHolders").child(userID)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                let userEmail = (snapshot.value as! NSDictionary)["Email"] as! String
                let userName = (snapshot.value as! NSDictionary)["Username"] as! String
                
                self.userNameLabel.text = "Email:"+userEmail +  " Username:" + userName
            }
            
            view.addSubview(userNameLabel)
            userNameLabel.anchor(left: view.leftAnchor, leftPadding: 10, right: view.rightAnchor, rightPadding: -10, top: view.topAnchor, topPadding: 100, bottom: nil, bottomPadding: 0, width: 0, height: 40)
        } else {
            print("Error, couldn't get user credentails")
        }
       
    }
    
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .white
        return label
    }()
    
    private func setUplogOutButton() {
        let imageName = "gear.png"
        let image = UIImage(named: imageName)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (_) in
            do {
                try Auth.auth().signOut()
            } catch let signOutError {
                print("Problem signing Out:", signOutError)
            }
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }))
        alertController.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        present(alertController, animated: true, completion: nil)
    }
}
