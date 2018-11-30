//
//  DatabaseAddController.swift
//  cs130
//
//  Created by Jesse Chen on 11/17/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseAddController {
    let formatter:DateFormatter
    
    init() {
        self.formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    
    func addPost(post:Post) {
        let db:DatabaseReference = Database.database().reference().child("posts/\(post.major)/\(post.course)")
        let key = db.childByAutoId().key
        
        let dateString = self.formatter.string(from: post.creationTime)
        
        let dbEntry:[String:Any] = ["creationTime": dateString,
                                    "creatorID": post.creator,
                                    "description": post.content,
                                    "isClosed": post.isClosed,
                                    "isTutorSearch": post.isTutorSearch,
                                    "title": post.title]
        db.updateChildValues(["/\(key)":dbEntry])
        post.ID = key
    }
    
    func addComment(comment:Comment) {
        let major:String = comment.rootPost!.major
        let course:String = comment.rootPost!.course
        let rootPostID:String = comment.rootPost!.ID as! String
        let db:DatabaseReference = Database.database().reference().child("/comments/\(major)/\(course)/\(rootPostID)")
        let key = db.childByAutoId().key
        
        let dateString = self.formatter.string(from: comment.creationTime)
        
        let dbEntry:[String:Any] = ["content": comment.content,
                                    "creationTime": dateString,
                                    "creatorID": comment.creator,
                                    "isPrivate": comment.isPrivate,
                                    "isResponse": comment.isResponse,
                                    "respondeeID": comment.respondeeID]
        db.updateChildValues(["/\(key)":dbEntry])
        comment.ID = key
    }
}
