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
    let parent:TextItem
    var isPrivate:Bool
    let rootPost:Post
    
    init(creator:User, content:String, parent:TextItem, isPrivate:Bool = false, rootPost:Post, creationTime:Date? = nil) {
        self.parent = parent
        self.isPrivate = isPrivate
        self.rootPost = rootPost
        super.init(creator:creator, content:content, creationTime:creationTime)
    }
    
    //adds entry to database /posts/major/course/rootPostID/commentID
    override func post() {
        let db:DatabaseReference = Database.database().reference()
        let major:String = self.rootPost.getMajor()
        let course:String = self.rootPost.getCourse()
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
    
    
    override func deleteSelf() {
        
    }
}
