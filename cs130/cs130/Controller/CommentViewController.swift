//
//  CommentViewController.swift
//  cs130
//
//  Created by Jesse Chen on 11/17/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class CommentViewController: UITableViewController {
    var formatter = DateFormatter()
    var comments = [Comment]()
    var post:Post?
    
    init(post:Post) {
        self.post = post
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.post = nil
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        view.backgroundColor = .white
        get(post:self.post!)
    }

    func get(post:Post) {
        fetchPostComments(major:post.major, course:post.course, postID:post.ID!)
    }
    
    func fetchPostComments(major:String, course:String, postID:String) {
        let db:DatabaseReference = Database.database().reference().child("comments/\(major)/\(course)/\(postID)")
        db.observe(.value, with: { (DataSnapshot) in
            var comments:[Comment] = []
            for item in DataSnapshot.children {
                let comment = item as! DataSnapshot
                let dic = comment.value as! NSDictionary
                let creator:User = User(id: dic["creatorID"] as! String)
                let content:String = dic["content"] as! String
                let isPrivate:Bool = dic["isPrivate"] as! Bool
                let isResponse:Bool = dic["isResponse"] as! Bool
                let respondeeID:String = dic["respondeeID"] as! String
                let creationTime:Date? = self.formatter.date(from: dic["creationTime"] as! String)
                let ID:String = comment.key
                print("created Comment(\(creator.getID),\n\(content),\n\(isPrivate),\n\(isResponse),\n\(respondeeID),\n\(creationTime),\n\(ID)")
                let fetchedComment:Comment = Comment(creator:creator,
                                                     content:content,
                                                     isPrivate:isPrivate,
                                                     isResponse:isResponse,
                                                     respondeeID:respondeeID,
                                                     creationTime:creationTime,
                                                     ID:ID)
                comments.append(fetchedComment)
            }
            self.comments += comments
            self.tableView.reloadData()
        })
    }
    
}
