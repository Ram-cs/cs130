//
//  TextItem.swift
//  cs130
//
//  Created by Jesse Chen on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation

class TextItem {
    let creator:User
    var content:String
    let creationTime:Date
    var ID:String?
    var child:Comment?
    
    init(creator:User, content:String) {
        self.creator = creator
        self.content = content
        self.creationTime = Date()
        self.ID = nil
        self.child = nil
    }
    
    func addChild(child:Comment) {
        self.child = child
    }
    
    func getChild() -> Comment? {
        return child
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
    
    func deleteSelf() {
        
    }
    
    
    
    
}
