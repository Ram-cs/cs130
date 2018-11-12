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
    
    func addCourse(courseId: String) {
        Database.database().reference().child("courses").child(courseId).child(self.id)
    }
    
    func removeCourse(courseId: String) {
        Database.database().reference().child("courses").child(courseId).child(self.id).removeValue()
    }
}
