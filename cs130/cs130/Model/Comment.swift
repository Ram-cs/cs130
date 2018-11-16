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
    var isPrivate:Bool
    let rootPost:Post
    let isResponse:Bool
    let respondeeID:String
    
    /// Initializes a Post object
    /// - parameters:
    ///     - creator:User: the User that is the author of the Comment
    ///     - content:String: the content of the Comment
    ///     - isPrivate:Bool: whether the message can be seen by everyone or only by the poster and rootPost poster
    ///     - rootPost:Post: the Post that this comment is replying to
    ///     - isResponse:Bool: whether this Comment is a response to another Comment
    ///     - respondeeID:String: the ID of the User that thie comment is responding to
    ///     - creationTime:Date: time that this Post was created/posted
    ///     - ID:String: Post identifier in the database
    /// - returns: a new Comment object
    init(creator:User, content:String, isPrivate:Bool = false, rootPost:Post, isResponse:Bool = false, respondeeID:String = "", creationTime:Date? = nil, ID:String? = nil) {
        self.isPrivate = isPrivate
        self.rootPost = rootPost
        self.isResponse = isResponse
        self.respondeeID = respondeeID
        super.init(creator:creator, content:content, creationTime:creationTime, ID:ID)
    }
}
