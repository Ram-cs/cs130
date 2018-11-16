//
//  cs130Tests.swift
//  cs130Tests
//
//  Created by Ram Yadav on 11/2/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import XCTest
import Firebase
@testable import cs130

class cs130Tests: XCTestCase {
    func testUsernameEmpty() {
        var username:UITextField?
        XCTAssertNil(username)
        let viewController = ViewController()
        XCTAssertEqual(username, viewController.emailTextField) ////check against nil or enterred username
    }
    
    func testPasswordEmpty() {
        var password:UITextField?
        XCTAssertNil(password)
        let viewController = ViewController()
        XCTAssertEqual(password, viewController.passwordTextField) //check against nil or enterred password
    }
    
    func passwordMatched() {
        var signUpViewController = SignUpController()
        var password = signUpViewController.passwordTextField;
        var re_enterPassword = signUpViewController.confirmPasswordTextField;
        XCTAssertEqual(password, re_enterPassword) //check if the enter password is matched
        
    }
    
    func checkForSignIn() {
        let viewController = ViewController()
        guard let email = viewController.emailTextField.text else {
            print("Emails is empty")
            return}
        guard let password = viewController.passwordTextField.text else {
            print("Password is empty")
            return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Problem with Signing In: ", err)
                return
            }
            print("Succefully Sign In")
        }
    }
    
    func checkForSignUp() {
        let signUpViewController = SignUpController()
        guard let email = signUpViewController.emailTextField.text, email.count > 0 else {
            print("Email is nil"); return}
        guard let username = signUpViewController.userNameTextField.text, username.count > 0 else {print("username is nil"); return}
        guard let password = signUpViewController.passwordTextField.text, password.count > 0 else {print("password is nil"); return}
        guard let confirmPassword = signUpViewController.confirmPasswordTextField.text, confirmPassword.count > 0 else {print("confirm password is nil");return}
        
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
                    }
                })
            }
        }
        
    }
    

}
