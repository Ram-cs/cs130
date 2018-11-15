//
//  Post.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class Post: TextItem {
    let title:String
    let course:String
    let major:String
    let isTutorSearch:Bool
    
    var isClosed:Bool
    
    init(creator:User, title:String, content:String, major:String, course:String, isTutorSearch:Bool, creationTime:Date? = nil) {
        self.title = title
        self.major = major
        self.course = course
        self.isTutorSearch = isTutorSearch
        self.isClosed = false
        super.init(creator:creator, content:content, creationTime:creationTime)
    }
    
    //adds entry to database /posts/major/course/postID
    override func post() {
        let db:DatabaseReference = Database.database().reference()
        let key = db.child("posts").child(self.major).child(self.course).childByAutoId().key
        
        let post:[String:Any] = ["description": self.content,
                                 "title": self.title,
                                 "isTutorSearch": self.isTutorSearch,
                                 "isClosed": self.isClosed]
        db.updateChildValues(["/posts/\(self.major)/\(self.course)/\(key)": post])
        
        self.ID = key as String?
        self.ref = db.child("posts").child(self.major).child(self.course).child(key)
    }
    
    func getMajor() -> String {
        return self.major
    }
    
    func getCourse() -> String {
        return self.course
    }
    
    func close() {
        self.isClosed = true
    }
    
    override func deleteSelf() {
        
    }
    
    
}
