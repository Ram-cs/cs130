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
    /// Unit test: whether we can retrieve courses from the database correctly
    func testCourseGet() {
        let expectation = XCTestExpectation(description: "Fetch courses from database")
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
            XCTAssertEqual(fetchedCourses[0].id, "CS130")
            XCTAssertEqual(fetchedCourses[0].title, "Software Programming")
            print("All tests passed")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20.0)
    }
    
    /// Unit test: whether we can increment user count of a course in the database
    func testCourseAddUserCnt() {
        let expectation = XCTestExpectation(description: "Get course user count")
        var old_cnt = 0
        Database.database().reference().child("majors").child("Computer Science").child("CS130").observeSingleEvent(of: .value) { (DataSnapshot) in
            let course = Course(major: "Computer Science", snapshot: DataSnapshot)
            old_cnt = course.userCnt
            course.updateUserCnt(add: true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        let expectation_2 = XCTestExpectation(description: "Get updated user count")
        Database.database().reference().child("majors").child("Computer Science").child("CS130").observe(.value) { (DataSnapshot) in
            let course = Course(major: "Computer Science", snapshot: DataSnapshot)
            if course.userCnt == old_cnt + 1 {
                expectation_2.fulfill()
            }
        }
        wait(for: [expectation_2], timeout: 30.0)
        
    }
    
    /// Unit test: whether we can retrieve courses of a user from database
    func testUserGet() {
        let dic = ["email": "Luke@gmail.com", "username": "Luke"]
        let user = User(uid: "hWFISzgYQ1YTrWocfrh1Svo3f682", dictionary: dic)
        let expectation = XCTestExpectation(description: "Get user's courses")
        // Copy of the User's observeCourses method
        var courses = [(String, String)]()
        user.userRef?.child("majors").observe(.value) { (DataSnapshot) in
            var newCourses = [(String, String)]()
            for item in DataSnapshot.children {
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
            }
            courses = newCourses
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(courses[0].0, "Computer Science")
        XCTAssertEqual(courses[0].1, "CS130")
        
    }
    
    /// Integration test: whether the user can enroll a course and update the course's user count
    func testUserAddCourse() {
        let dic = ["email": "Luke@gmail.com", "username": "Luke"]
        let user = User(uid: "hWFISzgYQ1YTrWocfrh1Svo3f682", dictionary: dic)
        let expectation = XCTestExpectation(description: "Get user's courses")
        var courses = [(String, String)]()

        // First, get the course list of the user
        // Copy of the User's observeCourses method to manually update the user's course lost
        user.userRef?.child("majors").observe(.value) { (DataSnapshot) in
            var newCourses = [(String, String)]()
            for item in DataSnapshot.children {
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
            }
            courses = newCourses
            user.courses = newCourses
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        
        // Then fetch a course
        let expectation_2 = XCTestExpectation(description: "Fetch courses from database")
        var old_cnt = 0
        var course:Course? = nil
        Database.database().reference().child("majors").child("Mechanical Engineering").child("ME101").observeSingleEvent(of: .value) { (DataSnapshot) in
                course = Course(major: "Mechanical Engineering", snapshot: DataSnapshot)
                old_cnt = (course?.userCnt)!
                expectation_2.fulfill()
        }
        wait(for: [expectation_2], timeout: 20.0)
        
        // Now add the course for the user
        XCTAssert(user.addCourse(course: course!))
        
        let expectation_3 = XCTestExpectation(description: "Check user's courses again")
        user.userRef?.child("majors").observe(.value) { (DataSnapshot) in
            var newCourses = [(String, String)]()
            for item in DataSnapshot.children {
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
            }
            courses = newCourses
            expectation_3.fulfill()
        }
        wait(for: [expectation_3], timeout: 10.0)
        XCTAssertEqual(courses[4].0, "Mechanical Engineering")
        XCTAssertEqual(courses[4].1, "ME101")
        
        // Wait for course to update user count
        let expectation_4 = XCTestExpectation(description: "Check if course user count is incremented")
        course?.itemRef?.observe(.value, with: { (DataSnapshot) in
            let dic = DataSnapshot.value as? NSDictionary
            if dic != nil {
                let new_cnt = dic?["users"] as! Int
                XCTAssertEqual(new_cnt, old_cnt + 1)
                expectation_4.fulfill()
                course?.itemRef?.removeAllObservers()
            }
        })
        wait(for: [expectation_4], timeout: 20.0)
    }
    
    //test case to check if the emailfield is filledout
    func testUsernameEmpty() {
        let viewController = LoginController()
        XCTAssertEqual("", viewController.emailTextField.text) ////check against empty or enterred username
    }
    
    //Test for if the password field is empty
    func testPasswordEmpty() {
        let viewController = LoginController()
        XCTAssertEqual("", viewController.passwordTextField.text) //check against empty or enterred password
    }
    
    //Test for whether the password is matched
    func passwordMatched() {
        var signUpViewController = SignUpController()
        var password = signUpViewController.passwordTextField;
        var re_enterPassword = signUpViewController.confirmPasswordTextField;
        XCTAssertEqual(password, re_enterPassword) //check if the enter password is matched
    }
    
    //Test for whether the user is SignedIn
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
    
    //Test for the user is signUp
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
                                    course:"CS130",
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
        XCTAssertTrue(orig.equals(otherPost:copy))
        //if(orig.equals(otherPost:copy)) {
            //print("Database Post Read-Write test passed!")
        //}
        //else {
            //print("Database Post Read-Write test failed!")
        //}
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
                                   course:"CS130",
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
        XCTAssertTrue(orig.equals(otherComment:copy))
        //if(orig.equals(otherComment:copy)) {
            //print("Database Comment Read-Write test passed!")
        //}
        //else {
            //print("Database Comment Read-Write test failed!")
        //}
    }
    
}
