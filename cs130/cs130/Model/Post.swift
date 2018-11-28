//
//  Post.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class Post: TextItem {
    let title:String
    let course:String
    let major:String
    let isTutorSearch:Bool
    var isClosed:Bool
    
    /// Initializes a Post object
    /// - parameters:
    ///     - creator: the User that is the author of the Post
    ///     - title: the title of the Post
    ///     - content: the description of the Post
    ///     - major: major that the Post is categorized under
    ///     - course: course that the Post is categorized under
    ///     - isTutorSearch: whether this Post is directed at Tutors
    ///     - creationTime: time that this Post was created/posted
    ///     - ID: Post identifier in the database
    /// - returns: a new Post object
    init(creator:String, title:String, content:String, major:String, course:String, isTutorSearch:Bool, creationTime:Date? = nil, ID:String? = nil) {
        self.title = title
        self.major = major
        self.course = course
        self.isTutorSearch = isTutorSearch
        self.isClosed = false
        super.init(creator:creator, content:content, creationTime:creationTime, ID:ID)
    }
    
    ///not functional yet
    init(major:String, course:String, ID:String) {
        let db:DatabaseReference = Database.database().reference().child("/posts/\(major)/\(course)/\(ID)")
        var postTitle:String = ""
        var postIsTutorSearch:Bool = false
        var postIsClosed:Bool = false
        var postCreationTime:Date? = Date()
        var postCreatorID:String = ""
        var postContent:String = ""
        db.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            let dic = DataSnapshot.value as! NSDictionary
            postTitle = dic["title"] as! String
            postIsTutorSearch = dic["isTutorSearch"] as! Bool
            postIsClosed = dic["isClosed"] as! Bool
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            postCreationTime = formatter.date(from: dic["creationTime"] as! String)
            postCreatorID = dic["creatorID"] as! String
            postContent = dic["description"] as! String
        })
        self.title = postTitle
        self.major = major
        self.course = course
        self.isTutorSearch = postIsTutorSearch
        self.isClosed = postIsClosed
        super.init(creator:postCreatorID, content:postContent, creationTime:postCreationTime, ID:ID)
    }
}
