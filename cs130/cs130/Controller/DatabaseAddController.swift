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
    

    /// Initializes a DatabaseAddController
    /// - return: a new DatabaseAddController
    init() {
        self.formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    
    ///adds a Post to the Firebase database
    /// - parameters:
    ///     - post: the Post object that is to be written to the database
    func addPost(post:Post) {
        let db:DatabaseReference = Database.database().reference().child("posts/\(post.major)/\(post.course)")
        let key = db.childByAutoId().key
        
        let dateString = self.formatter.string(from: post.creationTime)
        
        let dbEntry:[String:Any] = ["creationTime": dateString,
                                    "creatorUsername": post.creatorUsername,
                                    "creatorID": post.creator,
                                    "description": post.content,
                                    "isClosed": post.isClosed,
                                    "isTutorSearch": post.isTutorSearch,
                                    "title": post.title]
        db.updateChildValues(["/\(key)":dbEntry])
        post.ID = key
    }
    

    ///adds a Comment to the Firebase database
    /// - parameters:
    ///     - comment: the Comment object that is to be written to the database
    func addComment(comment:Comment) {
        let major:String = comment.rootPost!.major
        let course:String = comment.rootPost!.course
        let rootPostID:String = comment.rootPost!.ID as! String
        let db:DatabaseReference = Database.database().reference().child("comments/\(major)/\(course)/\(rootPostID)")
        let key = db.childByAutoId().key
        
        let dateString = self.formatter.string(from: comment.creationTime)
        
        let dbEntry:[String:Any] = ["content": comment.content,
                                    "creatorUsername": comment.creatorUsername,
                                    "creationTime": dateString,
                                    "creatorID": comment.creator,
                                    "isPrivate": comment.isPrivate,
                                    "isResponse": comment.isResponse,
                                    "respondeeID": comment.respondeeID]
        db.updateChildValues(["/\(key)":dbEntry])
        comment.ID = key
    }
}
