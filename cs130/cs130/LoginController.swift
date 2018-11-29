//
//  ViewController.swift
//  cs130
//
//  Created by Ram Yadav on 11/2/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase



class LoginController: UIViewController {
//    static var singletonUser: User?
    
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
        logoImageView.anchor(left: nil, leftPadding: 0, right: nil, rightPadding: 0, top: logoView.topAnchor, topPadding: 40, bottom: logoView.bottomAnchor, bottomPadding: -10, width: 200, height: 0)
        logoImageView.centerXAnchor.constraint(equalTo: logoView.centerXAnchor).isActive = true
//        logoImageView.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        return logoView
    }()
    
    let emailTextField: UITextField = {
        let email = UITextField();
        email.backgroundColor = UIColor(white: 0, alpha: 0.10)
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        email.textColor = .black
        email.borderStyle = .roundedRect
        email.font = UIFont.systemFont(ofSize: 16)
        return email
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField();
        password.backgroundColor = UIColor(white: 0, alpha: 0.10)
        password.textColor = .black
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .white
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let error = err {
                print("Error with verifying account", error)
                let get_error = self.errorHandler(err: error as NSError)
                self.userNameLabel.text = get_error
                return
            }
            
            print("Succefully signed In")
//            self.storeCredentials()
            let personalBoardController = PersonalBoardController()
            let navController = UINavigationController(rootViewController: personalBoardController)
            self.present(navController, animated: true, completion: nil)
        }
    }
//
//    private func storeCredentials() {
//        if((Auth.auth().currentUser?.uid) != nil) {
//            let userID : String = (Auth.auth().currentUser?.uid)!
//            print("Current user is: ", userID)
//
//            let ref = Database.database().reference().child("users").child(userID)
//            ref.observeSingleEvent(of: .value) { (snapshot) in
//                guard let dictionary = snapshot.value as? [String: Any] else {return}
//                LoginController.singletonUser = User(uid: userID, dictionary: dictionary)
//
//            }
//        } else {
//            print("Error, couldn't get user credentails")
//        }
//    }
    
    let dontHaveAccountButtton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignUp() {
        self.userNameLabel.text = ""
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //make bar color white
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        logoViewDisplay();
        
        setUpInputField() //for the input buttons
        signUp() //for the singup link
        
        addErrorLabel()
        
    }
    
    func addErrorLabel() {
        view.addSubview(userNameLabel)
        userNameLabel.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -340, width: 0, height: 40)
    }
    
    fileprivate func logoViewDisplay() {
        view.addSubview(logoContainerView)
        logoContainerView.anchor(left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, top: view.topAnchor, topPadding: 80, bottom: nil, bottomPadding: 0, width: 0, height: 250)
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
    
    struct LoginErrorCode {
        static let NETWORK_ERROR = "Network error occured"
        static let INVALID_EMAIL = "Invalid Email"
        static let WEAK_PASSWORD = "Weak Password,must be 6 at least character"
        static let WRONG_PASSWORD = "Invalid Username or Password"
        static let EMAIL_ALREADY_USE = "Email has already been used"
        static let USET_NOT_FOUND = "User not found"
        static let CREDENTIAL_IN_USE = "Email already exist"
    }
    
    private func errorHandler(err: NSError)->String {
        var error = ""
        
        if let errorCode = AuthErrorCode(rawValue: err.code) {
            switch errorCode {
            case .networkError:
                error = (LoginErrorCode.NETWORK_ERROR);
                break;
            case .invalidEmail:
                error = (LoginErrorCode.INVALID_EMAIL);
                break;
            case .weakPassword:
                error = (LoginErrorCode.WEAK_PASSWORD);
                break;
            case .wrongPassword:
                error = (LoginErrorCode.WRONG_PASSWORD);
                break;
            case .emailAlreadyInUse:
                error = (LoginErrorCode.EMAIL_ALREADY_USE);
                break;
            case .userNotFound:
                error = (LoginErrorCode.USET_NOT_FOUND);
                break;
            case .credentialAlreadyInUse:
                error = (LoginErrorCode.CREDENTIAL_IN_USE);
                break;
            default:
                break;
            }
        }
        return error
    }

}

