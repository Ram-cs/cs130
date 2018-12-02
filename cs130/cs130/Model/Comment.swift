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
    let rootPost:Post?
    let isResponse:Bool
    let respondeeID:String
    
    /// Initializes a Post object
    /// - parameters:
    ///     - creator: the userID that is the author of the Comment
    ///     - creatorUsername: username of the creator
    ///     - content: the content of the Comment
    ///     - isPrivate: whether the message can be seen by everyone or only by the poster and rootPost poster
    ///     - rootPost: the Post that this comment is replying to
    ///     - isResponse: whether this Comment is a response to another Comment
    ///     - respondeeID: the ID of the User that thie comment is responding to
    ///     - creationTime: time that this Post was created/posted
    ///     - ID: Post identifier in the database
    /// - returns: a new Comment object
    init(creator:String, creatorUsername:String, content:String, isPrivate:Bool = false, rootPost:Post? = nil, isResponse:Bool = false, respondeeID:String = "", creationTime:Date? = nil, ID:String? = nil) {
        self.isPrivate = isPrivate
        self.rootPost = rootPost
        self.isResponse = isResponse
        self.respondeeID = respondeeID
        super.init(creator:creator, creatorUsername:creatorUsername, content:content, creationTime:creationTime, ID:ID)
    }

    /// Compares this Comment to another Comment
    /// - parameters:
    ///     - otherComment: Comment that is being compared to
    /// - returns: equivalence of Comments
    func equals(otherComment:Comment) -> Bool {
        var comparisons:[Bool] = []
        comparisons.append(self.isPrivate == otherComment.isPrivate)
        comparisons.append(self.rootPost!.equals(otherPost:otherComment.rootPost!))
        comparisons.append(self.isResponse == otherComment.isResponse)
        comparisons.append(self.respondeeID == otherComment.respondeeID)
        comparisons.append(self.creator == otherComment.creator)
        comparisons.append(self.creatorUsername == otherComment.creatorUsername)
        comparisons.append(self.content == otherComment.content)
        comparisons.append(self.creationTime == otherComment.creationTime)
        comparisons.append(self.ID == otherComment.ID)
        for val in comparisons {
            if(!val) {
                return false
            }
        }
        return true
    }
}
