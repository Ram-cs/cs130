//
//  PostController.swift
//  cs130
//
//  Created by Jesse Chen on 11/14/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class PostViewController: UITableViewController {
    var formatter = DateFormatter()
    var posts = [Post]()
    let appUser:User = (UIApplication.shared.delegate as! AppDelegate).appUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        view.backgroundColor = .white
        //let courseList:[(String, String)] = [("Computer Science","130"),
        //                                    ("Engineering","183EW")]
        //get(user:appUser)
        fetchUserPosts(major:"Computer Science", course:"130")
    }
    
    func get(user:User)  {
        let userCourses:[(String, String)] = user.getCourses()
        for course in userCourses {
            print("fetch course")
            fetchUserPosts(major: course.0, course: course.1)
        }
    }
    
    func fetchUserPosts(major: String, course: String) {
        let db:DatabaseReference = Database.database().reference().child("posts/\(major)/\(course)")
        db.observe(.value, with: { (DataSnapshot) in
            var posts: [Post] = []
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
                                            major:major,
                                            course:course,
                                            isTutorSearch:isTutorSearch,
                                            creationTime:creationTime,
                                            ID:post.key)
                posts.append(fetchedPost)
                
            }
            self.posts += posts
            self.tableView.reloadData()
        })
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
    
    func setClosed(post:Post) {
        post.isClosed = true
    }
}
