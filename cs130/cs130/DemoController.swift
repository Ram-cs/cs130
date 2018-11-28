////
////  DemoController.swift
////  cs130
////
////  Created by Jesse Chen on 11/11/18.
////  Copyright © 2018 Ram Yadav. All rights reserved.
////
//
//import UIKit
//import FirebaseDatabase
//
//
//class DemoController: UITableViewController {
//    let group = DispatchGroup()
//    var comments:[Comment] = [Comment]()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        //setUpInputField()
//        //signUp()
//        
//        doStuff()
//        
//    }
//    
//    fileprivate func doStuff() {
//        print("doing stuff")
//        
//        let sample_user:User = User(id:"204578044")
//        
//        print("made it to here")
//        
//        let sample_post:Post = Post(creator:sample_user,
//                                    title: "POST TITLE",
//                                    content: "POST DESCRIPTION DESCRIPTION",
//                                    major: "Computer Science",
//                                    course: "130",
//                                    isTutorSearch: false)
//        
//        let sample_comment1 = Comment(creator:sample_user,
//                                      content: "this is a response1",
//                                      isPrivate: false,
//                                      rootPost:sample_post)
//        let sample_comment2 = Comment(creator:sample_user,
//                                      content: "2nd comment",
//                                      isPrivate: false,
//                                      rootPost:sample_post)
//        
//        print("whatttt")
//        
//        let dac:DatabaseAddController = DatabaseAddController()
//        
//        dac.addPost(post:sample_post)
//        dac.addComment(comment:sample_comment1)
//        dac.addComment(comment:sample_comment2)
//        print("successfully added posts and comments")
//        
//        cc.get(post:sample_post)
//        sleep(5)
//        
//        print("length of collectedComments")
//        print(self.comments.count)
//        //pc.post(post:sample_post)
//        
//        
//        let courseList:[(String, String)] = [("Computer Science","130"),
//                                             ("Engineering","183EW")]
//        
//        print("did stuff")
//        }
//    
//
//}
