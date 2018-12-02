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
    
    /// Tests whether we can retrieve courses from the database correctly
    func testCourseGet() {
        Database.database().reference().child("majors").observeSingleEvent(of: .value) { (DataSnapshot) in
            var fetchedCourses = [Course]()
            for item in DataSnapshot.children {
                let major = item as! DataSnapshot
                for course in major.children {
                    let newCourse = Course(major: major.key , snapshot: course as! DataSnapshot)
                    fetchedCourses.append(newCourse)
                }
            }
            XCTAssertEqual(fetchedCourses[0].major, "Computer Science")
            XCTAssertEqual(fetchedCourses[0].id, "130")
            XCTAssertEqual(fetchedCourses[0].title, "Software Engineering")
            XCTAssertEqual(fetchedCourses[0].professor, "Miryung Kim")
            print("All tests passed")
        }
        sleep(20)
    }
        
    func testUsernameEmpty() {
        var username:UITextField?
        XCTAssertNil(username)
        let viewController = LoginController()
        XCTAssertEqual(username, viewController.emailTextField) ////check against nil or enterred username
    }
    
    func testPasswordEmpty() {
        var password:UITextField?
        XCTAssertNil(password)
        let viewController = LoginController()
        XCTAssertEqual(password, viewController.passwordTextField) //check against nil or enterred password
    }
    
    func passwordMatched() {
        var signUpViewController = SignUpController()
        var password = signUpViewController.passwordTextField;
        var re_enterPassword = signUpViewController.confirmPasswordTextField;
        XCTAssertEqual(password, re_enterPassword) //check if the enter password is matched
        
    }
    
    func checkForSignIn() {
        let viewController = LoginController()
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

    func checkPostReadWrite() {
        let dac:DatabaseAddController = DatabaseAddController()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"

        let samplePost:Post = Post(creator:"204578044",
                                    creatorUsername:"bobthebuilder",
                                    title:"sample_title",
                                    content:"sample_content",
                                    major:"Computer Science",
                                    course:"130",
                                    isTutorSearch:false)
        dac.addPost(post:samplePost)
        let db:DatabaseReference = Database.database().reference().child("posts/\(samplePost.major)/\(samplePost.course)/\(samplePost.ID)")
        db.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let dic = DataSnapshot.value as! NSDictionary
            let creator:String = dic["creatorID"] as! String
            let creatorUsername:String = dic["creatorUsername"] as! String
            let title:String = dic["title"] as! String
            let description:String = dic["description"] as! String
            let isTutorSearch:Bool = dic["isTutorSearch"] as! Bool
            let creationTime:Date? = formatter.date(from: dic["creationTime"] as! String)

            let fetchedPost:Post = Post(creator:creator,
                                        creatorUsername:creatorUsername,
                                        title:title,
                                        content:description,
                                        major:samplePost.major,
                                        course:samplePost.course,
                                        isTutorSearch:isTutorSearch,
                                        creationTime:creationTime,
                                        ID:DataSnapshot.key)
            self.checkPostRead(orig:samplePost, copy:fetchedPost)
        })
    }

    func checkPostRead(orig:Post, copy:Post) {
        if(orig.equals(otherPost:copy)) {
            print("Database Post Read-Write test passed!")
        }
        else {
            print("Database Post Read-Write test failed!")
        }
    }

    func checkCommentReadWrite() {
        let dac:DatabaseAddController = DatabaseAddController()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let samplePost:Post = Post(creator:"204578044",
                                   creatorUsername:"bobthebuilder",
                                   title:"sample_title",
                                   content:"sample_content",
                                   major:"Computer Science",
                                   course:"130",
                                   isTutorSearch:false)
        dac.addPost(post:samplePost)
        let sampleComment:Comment = Comment(creator:"204578044",
                                            creatorUsername:"bobthebuilder",
                                            content:"sample_content",
                                            isPrivate:false,
                                            rootPost:samplePost,
                                            isResponse:false)
        dac.addComment(comment:sampleComment)
        let db:DatabaseReference = Database.database().reference().child("comments/\(samplePost.major)/\(samplePost.course)/\(samplePost.ID)/\(sampleComment.ID)")
        db.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let dic = DataSnapshot.value as! NSDictionary
            let creator:String = dic["creatorID"] as! String
            let creatorUsername:String = dic["creatorUsername"] as! String
            let content:String = dic["content"] as! String
            let isPrivate:Bool = dic["isPrivate"] as! Bool
            let isResponse:Bool = dic["isResponse"] as! Bool
            let respondeeID:String = dic["respondeeID"] as! String
            let creationTime:Date? = formatter.date(from: dic["creationTime"] as! String)

            let fetchedComment:Comment = Comment(creator:creator,
                                                creatorUsername:creatorUsername,
                                                content:content,
                                                isPrivate:isPrivate,
                                                rootPost:nil,
                                                isResponse:isResponse,
                                                respondeeID:respondeeID,
                                                creationTime:creationTime,
                                                ID:DataSnapshot.key)
            self.checkCommentRead(orig:sampleComment, copy:fetchedComment)
        })
    }

    func checkCommentRead(orig:Comment, copy:Comment) {
        if(orig.equals(otherComment:copy)) {
            print("Database Comment Read-Write test passed!")
        }
        else {
            print("Database Comment Read-Write test failed!")
        }
    }
    
}
