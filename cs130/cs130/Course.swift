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
    let major: String
    let id: String
    let title: String
    let professor: String
    let quarter: String
    let year: Int
    var userCnt: Int
    var postCnt: Int
    let itemRef:DatabaseReference?
    
    init(major: String, id: String, title: String, professor: String, quarter: String, year: Int) {
        self.major = major
        self.id = id
        self.title = title
        self.professor = professor
        self.quarter = quarter
        self.year = year
        self.userCnt = 0
        self.postCnt = 0
        self.itemRef = Database.database().reference().child("majors").child(major).child(id)
        self.setUpObserver()
    }
    
    init(major: String, snapshot: DataSnapshot) {
        self.major = major
        self.id = snapshot.key
        self.itemRef = snapshot.ref
        let val = snapshot.value as? NSDictionary
        if let data = val?["title"] as? String {self.title = data}
        else {self.title = ""}
        if let data = val?["professor"] as? String {self.professor = data}
        else {self.professor = ""}
        if let data = val?["quarter"] as? String {self.quarter = data}
        else {self.quarter = ""}
        if let data = val?["year"] as? Int {self.year = data}
        else {self.year = 9999}
        if let data = val?["users"] as? Int {self.userCnt = data}
        else {self.userCnt = 0}
        self.postCnt = 0
        self.setUpObserver()
    }
    
    func toString() -> String {
        return self.major + " " + self.id
    }
    
    // When add == true, increment user count, otherwise decrement
    func updateUserCnt(add: Bool) {
        self.itemRef?.runTransactionBlock({ (MutableData) -> TransactionResult in
            var dic = MutableData.value as? [String: AnyObject]
            var cnt = dic?["users"] as! Int
            if add {
                cnt += 1
            } else {
                cnt = max(cnt - 1, 0)
            }
            dic?["users"] = cnt as AnyObject
            MutableData.value = dic
            return TransactionResult.success(withValue: MutableData)
        })
    }
    
    func setUpObserver() {
        // Observe changes in user count
        self.itemRef?.observe(.value) { (DataSnapshot) in
            let dic = DataSnapshot.value as? NSDictionary
            self.userCnt = dic?["users"] as! Int
        }
        
        // Observe changes in post count
        let ref = Database.database().reference().child("posts").child(self.major).child(self.id)
        ref.observe(.value) { (DataSnapshot) in
            var cnt = 0
            for _ in DataSnapshot.children {
                cnt += 1
            }
            self.postCnt = cnt
        }
    }
}
