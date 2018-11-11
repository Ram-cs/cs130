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
    let name:String
    let id:String // A unique identifier
    let major:String
    let itemRef:DatabaseReference?
    
    init(name:String, id:String, major:String) {
        self.name = name
        self.id = id
        self.major = major
        self.itemRef = nil
    }
    
    init(snapshot:DataSnapshot) {
        self.itemRef = snapshot.ref
        let dic = snapshot.value as? NSDictionary
        if let dicName = dic?["name"] as? String {self.name = dicName}
        else {self.name = ""}
        if let dicId = dic?["id"] as? String {self.id = dicId}
        else {self.id = ""}
        if let dicMajor = dic?["major"] as? String {self.major = dicMajor}
        else {self.major = ""}
    }
}
