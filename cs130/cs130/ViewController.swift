//
//  ViewController.swift
//  cs130
//
//  Created by Ram Yadav on 11/2/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let logoContainerView: UIView = {
        let logoView = UIView()
        logoView.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175) //render background color
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "studyBuddyLogo")) //inserting inside background
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.black.cgColor
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFill
        logoView.addSubview(logoImageView)
        logoImageView.anchor(left: nil, leftPadding: 0, right: nil, rightPadding: 0, top: logoView.topAnchor, topPadding: 40, bottom: logoView.bottomAnchor, bottomPadding: -10, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        return logoView
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField();
        email.backgroundColor = UIColor(white: 0, alpha: 0.06)
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.textColor = .white
        email.borderStyle = .roundedRect
        email.font = UIFont.systemFont(ofSize: 16)
        return email
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField();
        password.backgroundColor = UIColor(white: 0, alpha: 0.06)
        password.textColor = .white
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.font = UIFont.systemFont(ofSize: 16)
        return password
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        return button
    }()
    
    
    let dontHaveAccountButtton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //make bar color white
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = GREEN_COLOR
        logoViewDisplay();
        
        setUpInputField() //for the input buttons
        signUp() //for the singup link
        
    }
    
    fileprivate func logoViewDisplay() {
        view.addSubview(logoContainerView)
        logoContainerView.anchor(left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, top: view.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 250)
    }
    
    fileprivate func setUpInputField() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: logoContainerView.bottomAnchor, topPadding: 40, bottom: nil, bottomPadding: 0, width: 0, height: 140)
    }
    
    fileprivate func signUp() {
        view.addSubview(dontHaveAccountButtton) //always put this first and then only anchor
        dontHaveAccountButtton.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: -12, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -40, width: 0, height: 40)
    }

}

