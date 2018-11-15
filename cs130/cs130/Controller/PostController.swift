//
//  PostController.swift
//  cs130
//
//  Created by Jesse Chen on 11/14/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class PostController {
    
    func get(user:User) -> [Post] {
        let userCourses:[(String, String)] = user.getCourses()
        return getCoursePosts(courses:userCourses)
    }
    
    func getCoursePosts(courses:[(String, String)]) -> [Post] {
        var posts:[Post] = [Post]()
        for course in courses {
            let db:DatabaseReference = Database.database().reference().child("posts/\(course.0)/\(course.1)")
            db.observe(.value, with: { (DataSnapshot) in
                for item in DataSnapshot.children {
                    let post = item as! DataSnapshot
                    let dic = post.value as! NSDictionary
                    let creator = User(id: dic["creatorID"] as! String)
                    let title:String = dic["title"] as! String
                    let description:String = dic["description"] as! String
                    let isTutorSearch = dic["isTutorSearch"] as! Bool
                    let creationTime:Date = dic["creationTime"] as! Date
                    let fetchedPost:Post = Post(creator:creator,
                                                title:title,
                                                content:description,
                                                major:course.0,
                                                course:course.1,
                                                isTutorSearch:isTutorSearch,
                                                creationTime:creationTime)
                    posts.append(fetchedPost)
                }
                
            })
        }
        return posts
    }
    
    func post(post:Post) {
        let db:DatabaseReference = Database.database().reference().child("posts/\(post.major)/\(post.course)")
        let key = db.childByAutoId().key
        let dbEntry:[String:Any] = ["creationTime": post.creationTime,
                                    "creatorID": post.creator.getID(),
                                    "description": post.content,
                                    "isClosed": post.isClosed,
                                    "isTutorSearch": post.isTutorSearch,
                                    "title": post.title]
        db.updateChildValues(["/\(key)":dbEntry])
    }
}
