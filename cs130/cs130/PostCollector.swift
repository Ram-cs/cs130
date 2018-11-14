//
//  PostCollector.swift
//  cs130
//
//  Created by Jesse Chen on 11/13/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostCollector {
    let user:User
    var courses:[(String, String)]
    
    init(user:User) {
        self.user = user
        self.courses = self.user.getCourses()
    }
    
    //need to be implemented
    func collectPosts() -> [Post] {
        let posts:[Post] = [Post]()
        for (major, course) in self.courses {
            //collect posts from /posts/\(major)/\(course)
        }
        return posts
    }
    
    //adds (major, course) to courses to collect posts from
    func addCourse(major:String, course:String) {
        self.courses.append((major, course))
    }
    
    //removes (major, course) from courses to collect posts from
    func removeCourse(major:String, course:String) {
        self.courses = self.courses.filter { $0 != (major, course) }
    }
    
    
}
