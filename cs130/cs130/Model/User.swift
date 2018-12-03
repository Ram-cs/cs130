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


/// Data structure for a user
class User {
    var uid:String = ""
    var email:String = ""
    var username:String = ""
    var userRef:DatabaseReference?
    var courses = [(String,String)]()
    
    /// Initializes a User object
    /// - parameters:
    ///     - uid: unique user identifier as defined by FirebaseAuth module
    ///     - dictionary: must contain fields "username" and "email"
    /// - returns: a User object
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary[UsersAttributes.USERNAME] as? String ?? ""
        self.email = dictionary[UsersAttributes.EMAIL] as? String ?? ""
        self.userRef = Database.database().reference().child(UsersAttributes.USERS).child(uid)
        self.observeCourses()
    }

    init(uid: String, dictionary: [String: Any], luc:LoadUserController) {
        self.uid = uid
        self.username = dictionary[UsersAttributes.USERNAME] as? String ?? ""
        self.email = dictionary[UsersAttributes.EMAIL] as? String ?? ""
        self.userRef = Database.database().reference().child(UsersAttributes.USERS).child(uid)
        self.observeCourses(luc:luc)
    }

    
    //this doesnt work
    func retrieveUserTriggerTransition(uid: String, upc:UserProfileController) {
        self.userRef? = Database.database().reference().child("users").child(uid)
        self.uid = uid
        //self.observeUserInfo()
        //self.observeCoursesTriggerTransition(upc:upc)
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
            self.userRef?.child("majors").child(course.toString()).setValue(courseInfo)
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
            self.userRef?.child("majors").child(course.toString()).removeValue()
            course.updateUserCnt(add: false)
            return true
        }
        else {
            return false
        }
    }
    
    // Set up an observer to asynchronously listen to changes in the user's courses, updating the list of courses stored in self
    fileprivate func observeCourses() {
        self.userRef?.child("majors").observe(.value) { (DataSnapshot) in
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
    
    //dont use this
    fileprivate func observeCourses(luc:LoadUserController) {
        self.userRef?.child("majors").observe(.value) { (DataSnapshot) in
            var newCourses = [(String,String)]()
            /*let val = DataSnapshot.value as? NSDictionary
            var unparsedData:String = ""
            if let data = val?["courses"] as? String {unparsedData = data}
            self.courses = DatabaseAddController.parseUserCourseData(userCourseData:unparsedData)
            print("about to transtion!!")

            lc.transitionToBoard()*/

            print("observeCourses(LoadUserController)")
            for item in DataSnapshot.children {
                print("for course in userdatabase!!!")
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
                print("got a course, got a course!!")
            }
            self.courses = newCourses
            luc.transitionToBoard()
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
}
