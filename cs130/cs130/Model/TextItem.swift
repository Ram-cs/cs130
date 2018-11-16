//
//  TextItem.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class TextItem {
    let creator:User
    var content:String
    let creationTime:Date
    var ID:String?
    var child:Comment?
    var ref:DatabaseReference?
    
    
    /// Initializes a TextItem object
    /// - parameters:
    ///     - creator:User: the User that is the author of the Comment
    ///     - content:String: the content of the TextItem
    ///     - creationTime:Date: time that this TextItem was created/posted
    ///     - ID:String: TextItem identifier in the database
    /// - returns: a new TextItem object
    init(creator:User, content:String, creationTime:Date? = nil, ID:String? = nil) {
        self.creator = creator
        self.content = content
        if creationTime == nil {
            self.creationTime = Date()
        }
        else {
            self.creationTime = creationTime as! Date
        }
        self.ID = ID
        self.child = nil
        self.ref = nil
    }
}
