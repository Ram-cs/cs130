//
//  Comment.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class Comment: TextItem {
    var isPrivate:Bool
    let rootPost:Post
    let isResponse:Bool
    let respondeeID:String
    
    init(creator:User, content:String, isPrivate:Bool = false, rootPost:Post, isResponse:Bool = false, respondeeID:String = "", creationTime:Date? = nil, ID:String? = nil) {
        self.isPrivate = isPrivate
        self.rootPost = rootPost
        self.isResponse = isResponse
        self.respondeeID = respondeeID
        super.init(creator:creator, content:content, creationTime:creationTime, ID:ID)
    }
    
    //adds entry to database /posts/major/course/rootPostID/commentID
    override func post() {
        let db:DatabaseReference = Database.database().reference()
        let major:String = self.rootPost.major
        let course:String = self.rootPost.course
        let rootPostID:String = (self.rootPost.getID())!
        let key:String = db.child("comments").child(major).child(course).child(rootPostID).childByAutoId().key
        
        let post:[String:Any] = ["content": self.content,
                                 "isPrivate": self.isPrivate,
                                 "rootPostID": rootPostID]
        db.updateChildValues(["/comments/\(major)/\(course)/\(rootPostID)/\(key)": post])
        
        self.ID = key as String?
        self.ref = db.child("posts").child(major).child(course).child(rootPostID).child(key)
        
    }
    
    func setPrivate() {
        self.isPrivate = true
    }
    
    func setPublic() {
        self.isPrivate = false
    }
}
