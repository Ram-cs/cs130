//
//  CommentController.swift
//  cs130
//
//  Created by Jesse Chen on 11/14/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentController {
    let formatter:DateFormatter
    
    init() {
        self.formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    func get(post:Post) -> [Comment] {
        return get(major:post.major, course:post.course, postID: post.ID as! String)
        
    }
    
    func get(major:String, course:String, postID:String) -> [Comment] {
        var comments:[Comment] = [Comment]()
        let db:DatabaseReference = Database.database().reference().child("comments/\(major)/\(course)/\(postID)")
        db.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            for item in DataSnapshot.children {
                let comment = item as! DataSnapshot
                let dic = comment.value as! NSDictionary
                let creator:User = User(id: dic["creatorID"] as! String)
                let content:String = dic["content"] as! String
                let isPrivate:Bool = dic["isPrivate"] as! Bool
                let rootPost:Post = Post(major:major, course:course, ID:postID)
                let isResponse:Bool = dic["isResponse"] as! Bool
                let respondeeID:String = dic["respondeeID"] as! String
                let creationTime:Date? = self.formatter.date(from: dic["creationTime"] as! String)
                let ID:String = comment.key
                //this is where i'm at
                //i think the issue is caused by everything being within the db.observeSingleEvent block
                // i think if we move stuff out of the block it might work: that's what luke did lol
                //let fetchedComment:Comment = Comment()
            }
            
            
        })
        
        return [Comment]()
    }
    
    func post(comment:Comment) {
        let major:String = comment.rootPost.major
        let course:String = comment.rootPost.course
        let rootPostID:String = comment.rootPost.ID as! String
        let db:DatabaseReference = Database.database().reference().child("/comments/\(major)/\(course)/\(rootPostID)")
        let key = db.childByAutoId().key
        
        let dateString = self.formatter.string(from: comment.creationTime)
        
        let dbEntry:[String:Any] = ["content": comment.content,
                                    "creationTime": dateString,
                                    "creatorID": comment.creator.getID(),
                                    "isPrivate": comment.isPrivate,
                                    "isResponse": comment.isResponse,
                                    "respondeeID": comment.respondeeID]
        
        db.updateChildValues(["/\(key)":dbEntry])
    }
    
}
