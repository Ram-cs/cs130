//
//  User.swift
//  cs130
//
//  Created by Runjia Li on 11/10/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
    
    // Get user from database, based on user ID
    init(id: String) {
        self.userRef = Database.database().reference().child("users").child(id)
        self.id = id
        var userMajor = ""
        self.userRef?.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let dic = DataSnapshot.value as? NSDictionary
            userMajor = (dic?["major"] as? String)!
        })
        self.major = userMajor
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
    
    // Add self to database (when creating new user)
    func addToDatabase() {
        self.userRef?.child("major").setValue(self.major)
    }
    
    func hasCourse(course: Course) -> Bool {
        // Check if user is already enrolled in course
        for item in self.courses {
            if item.0 == course.major && item.1 == course.id {
                return true
            }
        }
        return false
    }
    
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
    
    // Set up observer to asynchronously listen to changes in user's classes
    func observeCourses() {
        self.userRef?.child("courses").observe(.value, with: { (DataSnapshot) in
            var newCourses = [(String,String)]()
            for item in DataSnapshot.children {
                let course = item as! DataSnapshot
                let dic = course.value as! NSDictionary
                let major = dic["major"] as! String
                let id = dic["id"] as! String
                newCourses.append((major, id))
            }
            self.courses = newCourses
        })
    }
    
    func getID() -> String {
        return self.id
    }
    
    //returns of array of (major, courseID)
    func getCourses() -> [(String,String)] {
        // return [(String, String)]()
        return self.courses
    }
}
