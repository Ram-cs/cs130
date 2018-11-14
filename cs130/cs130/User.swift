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
    
    init(id: String, major: String) {
        self.id = id
        self.major = major
        self.userRef = Database.database().reference().child("users").child(id)
    }
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        self.userRef = snapshot.ref
        let dic = snapshot.value as? NSDictionary
        if let dicMajor = dic?["major"] as? String {self.major = dicMajor}
        else {self.major = ""}
    }
    
    // Add self to database (when creating new user)
    func addToDatabase() {
        self.userRef?.child("major").setValue(self.major)
    }
    
    func addCourse(course: Course) {
        let major = course.major
        let courseId = course.id
        let key = self.userRef?.child("courses").childByAutoId().key
        let courseInfo = ["major": major, "id": courseId]
        let updates = ["/courses/\(key)": courseInfo]
        self.userRef?.updateChildValues(updates)
        // Update user count for course
        course.updateUserCnt(add: true)
        
    }
    
    func removeCourse(course: Course) {
        let major = course.major
        let courseId = course.id
        self.userRef?.child("courses").observe(.value, with: { (DataSnapshot) in
            for item in DataSnapshot.children {
                let aCourse = item as! DataSnapshot
                let dic = aCourse.value as? NSDictionary
                if dic?["major"] as? String == major && dic?["id"] as? String == courseId {
                    self.userRef?.child("courses").child(aCourse.key).removeValue()
                }
            }
        })
        course.updateUserCnt(add: false)
    }
    
    //returns of array of (major, courseID)
    func getCourses() -> [(String,String)] {
        return [(String, String)]()
    }
}
