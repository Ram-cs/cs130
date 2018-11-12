//
//  Course.swift
//  cs130
//
//  Created by Runjia Li on 11/10/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Course {
    /*
    let name:String
    let id:String // A unique identifier
    let major:String
    let profName:String
    let quarter:String
    let year:Int
    */
    let major: String
    let id: String
    let attributes: [String: AnyObject]
    let itemRef:DatabaseReference?
    
    init(major: String, id: String) {
        self.major = major
        self.id = id
        self.itemRef = Database.database().reference().child("majors").child(major).child(id)
        self.attributes = [:]
    }
    
    init(major: String, snapshot: DataSnapshot) {
        self.major = major
        self.id = snapshot.key
        self.itemRef = snapshot.ref
        self.attributes = snapshot.value as? [String: AnyObject] ?? [:]
    }
}
