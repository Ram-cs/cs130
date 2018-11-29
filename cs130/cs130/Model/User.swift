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
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.password = dictionary["password"] as? String ?? ""
        self.observeCourses()
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
    
    /// Set up an observer to asynchronously listen to changes in the user's courses, updating the list of courses stored in self
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
    
    /// Gets the unique identifier of user
    /// - returns: the user's unique identifier, a string
    func getID() -> String {
        return self.uid
    }
    
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
