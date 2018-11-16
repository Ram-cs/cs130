//
//  SignUpController.swift
//  cs130
//
//  Created by Ram Yadav on 11/9/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    let emailTextField: UITextField = {
        let email = UITextField(frame: .zero);
        email.backgroundColor = .white
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        email.textColor = .black
        email.clearButtonMode = .whileEditing
        email.borderStyle = .roundedRect
        email.font = UIFont.systemFont(ofSize: 16)
        email.sizeToFit()
        email.translatesAutoresizingMaskIntoConstraints = true
        return email
    }()
    
    let userNameTextField: UITextField = {
        let username = UITextField();
        username.clearButtonMode = .whileEditing
        username.backgroundColor = .white
        username.attributedPlaceholder = NSAttributedString(string: "Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        username.textColor = .black
        username.borderStyle = .roundedRect
        username.font = UIFont.systemFont(ofSize: 16)
        username.sizeToFit()
        username.translatesAutoresizingMaskIntoConstraints = true
        return username
    }()
    
//    let universityName: UITextField = {
//        let name = UITextField();
//        name.clearButtonMode = .whileEditing
//        name.backgroundColor = .white
//        name.attributedPlaceholder = NSAttributedString(string: "Univeristy Name",
//                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//        name.textColor = .black
//        name.borderStyle = .roundedRect
//        name.font = UIFont.systemFont(ofSize: 16)
//        name.sizeToFit()
//        name.translatesAutoresizingMaskIntoConstraints = true
//        return name
//    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField();
        password.clearButtonMode = .whileEditing
        password.backgroundColor = .white
        password.textColor = .black
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        password.isSecureTextEntry = true
        
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 16)
        password.sizeToFit()
        password.translatesAutoresizingMaskIntoConstraints = true
        return password
    }()
    
    let confirmPasswordTextField: UITextField = {
        let password = UITextField();
        password.clearButtonMode = .whileEditing
        password.backgroundColor = .white
        password.textColor = .black
        password.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 16)
        password.sizeToFit()
        password.translatesAutoresizingMaskIntoConstraints = true
        return password
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        button.addTarget(self, action: #selector(signUpHandle), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //make bar color white
        return .lightContent
    }
    
    @objc func signUpHandle() {
        guard let email = emailTextField.text, email.count > 0 else {print(1); return}
        guard let username = userNameTextField.text, username.count > 0 else {print(2); return}
        guard let password = passwordTextField.text, password.count > 0 else {print(3); return}
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword.count > 0 else {print(4);return}
        
        if(password != confirmPassword) {
            print("Password doesn't matched! Try again!")
            return
        }
        
        Firebase.Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let error = err {
                print("Account can not be created!", error)
                return
            } else {
                //now store the credentials to our databse
                guard let uid = user?.uid else {return}
                let ref = Database.database().reference().child("users").child(uid)
                let dictionary = ["Email": email, "Username": username, "Password": password]
                let values = [uid: dictionary]
                
                ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    if let error = err {
                        print("Error storing data!", error)
                        return
                    } else {
                        print("Account succefully created!")
                        print("Succefully data saved!")
                        
                        //dismiss this view controller now
//                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    let alreadyHaveAccountButtton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175) //render background color
        setUpInputField()
        signUp()
        
    }
    
    fileprivate func setUpInputField() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, passwordTextField, confirmPasswordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        
        stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }

    
    fileprivate func signUp() {
        view.addSubview(alreadyHaveAccountButtton) //always put this first and then only anchor
        alreadyHaveAccountButtton.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: -12, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -40, width: 0, height: 40)
    }
}
