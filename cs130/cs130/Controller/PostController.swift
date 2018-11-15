//
//  PostController.swift
//  cs130
//
//  Created by Jesse Chen on 11/14/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostController {
    let formatter:DateFormatter
    
    init() {
        self.formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    func get(user:User) -> [Post] {
        let userCourses:[(String, String)] = user.getCourses()
        return getCoursePosts(courses:userCourses)
    }
    
    func getCoursePosts(courses:[(String, String)]) -> [Post] {
        var posts:[Post] = [Post]()
        for course in courses {
            let db:DatabaseReference = Database.database().reference().child("posts/\(course.0)/\(course.1)")
            db.observeSingleEvent(of: .value, with: { (DataSnapshot) in
                for item in DataSnapshot.children {
                    let post = item as! DataSnapshot
                    let dic = post.value as! NSDictionary
                    let creator:User = User(id: dic["creatorID"] as! String)
                    let title:String = dic["title"] as! String
                    let description:String = dic["description"] as! String
                    let isTutorSearch:Bool = dic["isTutorSearch"] as! Bool
                    let creationTime:Date? = self.formatter.date(from: dic["creationTime"] as! String)
                    print("created Post(\(creator.getID()), \n\(title), \n\(description), \n\(isTutorSearch), \n\(dic["creationTime"] as! String)\n")
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
        print("finished getting posts")
        print("\(posts.count)")
        return posts
    }
    
    func post(post:Post) {
        let db:DatabaseReference = Database.database().reference().child("posts/\(post.major)/\(post.course)")
        let key = db.childByAutoId().key
        

        let dateString = self.formatter.string(from: post.creationTime)
        
        let dbEntry:[String:Any] = ["creationTime": dateString,
                                    "creatorID": post.creator.getID(),
                                    "description": post.content,
                                    "isClosed": post.isClosed,
                                    "isTutorSearch": post.isTutorSearch,
                                    "title": post.title]
        db.updateChildValues(["/\(key)":dbEntry])
    }
}
