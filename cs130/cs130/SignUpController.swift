//
//  SignUpController.swift
//  cs130
//
//  Created by Ram Yadav on 11/9/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    let emailTextField: UITextField = {
        let email = UITextField();
        email.backgroundColor = UIColor(white: 0, alpha: 0.04)
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        email.textColor = .black
        email.clearButtonMode = .whileEditing
        email.borderStyle = .roundedRect
        email.font = UIFont.systemFont(ofSize: 16)
        return email
    }()
    
    let userNameTextField: UITextField = {
        let username = UITextField();
        username.clearButtonMode = .whileEditing
        username.backgroundColor = UIColor(white: 0, alpha: 0.04)
        username.attributedPlaceholder = NSAttributedString(string: "Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        username.textColor = .black
        username.borderStyle = .roundedRect
        username.font = UIFont.systemFont(ofSize: 16)
        return username
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField();
        password.clearButtonMode = .whileEditing
        password.backgroundColor = UIColor(white: 0, alpha: 0.04)
        password.textColor = .black
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        password.isSecureTextEntry = true
        
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 16)
        return password
    }()
    
    let confirmPasswordTextField: UITextField = {
        let password = UITextField();
        password.clearButtonMode = .whileEditing
        password.backgroundColor = UIColor(white: 0, alpha: 0.04)
        password.textColor = .black
        password.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 16)
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
        return button
    }()
    
    let alreadyHaveAccountButtton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
