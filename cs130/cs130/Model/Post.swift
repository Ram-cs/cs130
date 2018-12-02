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
    ///     - creator: the userID that is the author of the Post
    ///     - creatorUsername: username of the creator
    ///     - title: the title of the Post
    ///     - content: the description of the Post
    ///     - major: major that the Post is categorized under
    ///     - course: course that the Post is categorized under
    ///     - isTutorSearch: whether this Post is directed at Tutors
    ///     - creationTime: time that this Post was created/posted
    ///     - ID: Post identifier in the database
    /// - returns: a new Post object
    init(creator:String, creatorUsername: String, title:String, content:String, major:String, course:String, isTutorSearch:Bool, creationTime:Date? = nil, ID:String? = nil) {
        self.title = title
        self.major = major
        self.course = course
        self.isTutorSearch = isTutorSearch
        self.isClosed = false
        super.init(creator:creator, creatorUsername:creatorUsername, content:content, creationTime:creationTime, ID:ID)
    }

    func equals(otherPost:Post) -> Bool {
        var comparisons:[Bool] = []
        comparisons.append(self.title == otherPost.title)
        comparisons.append(self.course == otherPost.course)
        comparisons.append(self.major == otherPost.major)
        comparisons.append(self.isTutorSearch == otherPost.isTutorSearch)
        comparisons.append(self.isClosed == otherPost.isClosed)
        comparisons.append(self.creator == otherPost.creator)
        comparisons.append(self.creatorUsername == otherPost.creatorUsername)
        comparisons.append(self.content == otherPost.content)
        comparisons.append(self.creationTime == otherPost.creationTime)
        comparisons.append(self.ID == otherPost.ID)
        for val in comparisons {
            if(!val) {
                return false
            }
        }
        return true
    }
}
