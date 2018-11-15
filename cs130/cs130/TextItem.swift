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
    
    //to be overridden by subclasses: Post, Comment
    //self.ID and self.ref should be initialized here
    func post() {}
    
    func addChild(child:Comment) {
        self.child = child
    }
    
    func getChild() -> Comment? {
        return self.child
    }
    
    //returns nil is this TextItem has not been posted yet
    func getID() -> String? {
        return self.ID
    }
    
    func hasChild() -> Bool {
        if self.child == nil {
            return false
        }
        return true
    }
    
    func deleteChild() -> Comment? {
        let deadChild:Comment? = self.child
        if self.hasChild() {
            self.child = self.child?.getChild()
        }
        return deadChild
    }
    
    //does not work yet: deleteSelf() still needs to be implemented
    func deleteAllChildren() {
        if self.child != nil {
            self.child?.deleteChain()
        }
    }
    
    //deleteAllChildren() helper function
    private func deleteChain() {
        if self.child == nil {
            self.deleteSelf()
        }
        else {
            self.child?.deleteChain()
            self.deleteSelf()
        }
    }
    
    func editContent(newContent:String) {
        self.content = newContent
    }
    
    
    func deleteSelf() {}
    
    
    
    
}
