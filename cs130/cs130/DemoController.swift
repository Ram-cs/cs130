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
//class DemoController: UIViewController {
// 
//    let group = DispatchGroup()
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
//        print("whatttt")
//        
//        let pc:PostController = PostController()
//        //pc.post(post:sample_post)
//        //pc.post(post:sample_post)
//        
//        let courseList:[(String, String)] = [("Computer Science","130"),
//                                             ("Engineering","183EW")]
//        let collectedPosts:[Post] = pc.getCoursePosts(courses:courseList)
//        
//        for post in collectedPosts {
//            print("\(post.title)")
//        }        
//        group.notify(queue: .main){
//        print("NUM OF COLLECTED POSTS:")
//        print(collectedPosts.count)
//        
//        print("did stuff")
//        }
//        
//        
//    }
//    
//
//}
