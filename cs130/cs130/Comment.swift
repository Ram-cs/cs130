//
//  Comment.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Comment: TextItem {
    let parent:TextItem
    var isPrivate:Bool
    let isResponse:Bool
    let rootPost:Post
    var commentRef:DatabaseReference?
    
    init(creator:User, content:String, parent:TextItem, isPrivate:Bool, isResponse:Bool, rootPost:Post) {
        self.parent = parent
        self.isPrivate = isPrivate
        self.isResponse = isResponse
        self.rootPost = rootPost
        self.commentRef = nil
        super.init(creator:creator, content:content)
    }
    
    //adds entry to database /posts/major/course/postID
    func post() {
        let db:DatabaseReference = Database.database().reference()
        let major:String = self.rootPost.getMajor()
        let course:String = self.rootPost.getCourse()
        let key:String = db.child("comments").child(major).child(course).childByAutoId().key
        
        self.ID = key as String?
        let post:[String:Any] = ["content": self.content]
        db.updateChildValues(["/comments/\(major)/\(course)/\(key)": post])
        
        self.commentRef = db.child("posts").child(major).child(course).child(key)
        
    }
    
    func setPrivate() {
        self.isPrivate = true
    }
    
    func setPublic() {
        self.isPrivate = false
    }
    
    
    override func deleteSelf() {
        
    }
}
