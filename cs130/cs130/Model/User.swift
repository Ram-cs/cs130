//
//  User.swift
//  cs130
//
//  Created by Runjia Li on 11/10/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

/// This class defines a user
class User {
    var uid:String = ""
    var email:String = ""
    var password:String = ""
    var username:String = ""
    var userRef:DatabaseReference?
    var courses = [(String,String)]()
    
    // Store newly created user in database
    func storeUser(uid: String, email: String, password: String, username: String) {
        self.uid = uid
        self.email = email
        self.password = password
        self.username = username
        self.userRef = Database.database().reference().child("users").child(uid)
        // Add the user to the database as an entry (when creating a new user)
      
        let ref = Database.database().reference().child("users")
        let dictionary = ["Email": email, "Username": username, "Password": password]
        let values = [uid: dictionary]
        
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let error = err {
                print("Error with creating account", error)
                let get_error = self.errorHandler(err: error as NSError)
                print(get_error)
                return
            } else {
                print("Account succefully created!")
                print("Succefully data saved!")
            }
        })
        self.observeUserInfo()
        self.observeCourses()
    }
    
    // Get user with given id from database
    func retriveUser(uid: String) {
        self.userRef? = Database.database().reference().child("users").child(uid)
        self.uid = uid
        self.observeUserInfo()
        self.observeCourses()
    }
    
    func retrieveUserTriggerTransition(uid: String, upc:UserProfileController) {
        self.userRef? = Database.database().reference().child("users").child(uid)
        self.uid = uid
        self.observeUserInfo()
        self.observeCoursesTriggerTransition(upc:upc)
    }
    
    /// Check if the user is already enrolled in a course
    /// - parameters:
    ///     - course: a course of interest
    /// - returns: whether the user is already enrolled or not
    func hasCourse(course: Course) -> Bool {
        for item in self.courses {
            if item.0 == course.major && item.1 == course.id {
                return true
            }
        }
        return false
    }
    
    func observeUserInfo() {
        self.userRef?.observe(.value) { (DataSnapshot) in
            let val = DataSnapshot.value as? NSDictionary
            if let data = val?["email"] as? String {self.email = data}
            if let data = val?["password"] as? String {self.password = data}
            if let data = val?["username"] as? String {self.username = data}
        }
    }
    
    /// Let the user enroll in a course
    /// - parameters:
    ///     - course: a course of interest
    /// - returns: whether the course is successfully enrolled or not (because the user has already enrolled)
    func addCourse(course: Course) -> Bool {
        if self.hasCourse(course: course) {
            return false
        }
        else {
            let courseInfo = ["major": course.major, "id": course.id]
            self.userRef?.child("courses").child(course.toString()).setValue(courseInfo)
            course.updateUserCnt(add: true)
            return true
        }
    }
    
    /// Let the user drop a course
    /// - parameters:
    ///     - course: a course of interest
    /// - returns: whether the course is successfully dropped or not (because the user has not yet enrolled)
    func removeCourse(course: Course) -> Bool{
        if self.hasCourse(course: course) {
            self.userRef?.child("courses").child(course.toString()).removeValue()
            course.updateUserCnt(add: false)
            return true
        }
        else {
            return false
        }
    }
    
    /// Set up an observer to asynchronously listen to changes in the user's courses. This is called
    /// within the constructor
    func observeCourses() {
        self.userRef?.child("courses").observe(.value) { (DataSnapshot) in
            var newCourses = [(String,String)]()
            for item in DataSnapshot.children {
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
            }
            self.courses = newCourses
        }
    }
    
    func observeCoursesTriggerTransition(upc:UserProfileController) {
        self.userRef?.observe(.value) { (DataSnapshot) in
            var newCourses = [(String,String)]()
            let val = DataSnapshot.value as? NSDictionary
            var unparsedData:String = ""
            if let data = val?["courses"] as? String {unparsedData = data}
            self.courses = DatabaseAddController.parseUserCourseData(userCourseData:unparsedData)
            print("about to transtion!!")

            upc.transitionToBoard()


            //for item in DataSnapshot.children {

                //let course = item as! DataSnapshot
                //let dic = course.value as! NSDictionary
                //let major = dic["major"] as! String
                //let id = dic["id"] as! String
                //newCourses.append((major, id))
            //}
            //self.courses = newCourses
            //upc.transitionToBoard()
        }
    }
    

    func getID() -> String {
        return self.uid
    }
    
    //returns of array of (major, courseID)

    /// Gets the courses of the user
    /// - returns: an array of (major, courseID) that the user is currently enrolled in
    func getCourses() -> [(String,String)] {
        // return [(String, String)]()
        return self.courses
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
