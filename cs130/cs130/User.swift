//
//  User.swift
//  cs130
//
//  Created by Runjia Li on 11/10/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

/// This class defines a user
class User {
    let id:String
    let major:String
    let userRef:DatabaseReference?
    var courses = [(String,String)]()
    
    init(id: String, major: String) {
        self.id = id
        self.major = major
        self.userRef = Database.database().reference().child("users").child(id)
        self.addToDatabase()
        self.observeCourses()
    }
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        self.userRef = snapshot.ref
        let dic = snapshot.value as? NSDictionary
        if let dicMajor = dic?["major"] as? String {self.major = dicMajor}
        else {self.major = ""}
        self.observeCourses()
    }
    
    /// Add the user to the database as an entry (when creating a new user)
    func addToDatabase() {
        self.userRef?.child("major").setValue(self.major)
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
    
    /// Gets the courses of the user
    /// - returns: an array of (major, courseID) that the user is currently enrolled in
    func getCourses() -> [(String,String)] {
        // return [(String, String)]()
        return self.courses
    }
}
