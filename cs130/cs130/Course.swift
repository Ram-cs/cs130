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
    let id: String
    let attributes: [String: AnyObject]
    let itemRef:DatabaseReference?
    
    init(id: String) {
        self.id = id
        self.itemRef = Database.database().reference().child("courses").child(id)
        self.attributes = [:]
    }
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        self.itemRef = snapshot.ref
        self.attributes = snapshot.value as? [String: AnyObject] ?? [:]
    }
}
