//
//  PostController.swift
//  cs130
//
//  Created by Andrew Yoon on 11/22/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

/// This view controller displays a post and its comments
class PostController: UIViewController, UIScrollViewDelegate {
    let rootPost:Post?
    var formatter = DateFormatter()
    var comments = [Comment]()
    
    /// Initializes a PostController
    /// - parameters:
    ///     - rootPost: Post object that user will be responding to
    /// - returns: a new PostController object
    init(rootPost:Post) {
        self.rootPost = rootPost
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        rootPost = nil
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = ""

        let backButtonItem = navigationItem.backBarButtonItem
        navigationItem.leftBarButtonItem = backButtonItem
        
        let empty = UIButton(type: .system);
        empty.isEnabled = false
        let emptyItem = UIBarButtonItem.init(customView: empty)
        navigationItem.rightBarButtonItem = emptyItem
        view.backgroundColor = PANEL_GRAY
        
        fetchPostComments()
        setUpRefresh()
        //setUpStack()
        setUpReplyButton()
    }

    /// Fetches comments from the firebase database for a specific post
    /// stores the comments in self.comments
    func fetchPostComments() {
        let major:String = self.rootPost!.major
        let course:String = self.rootPost!.course
        let rootPostID:String = self.rootPost!.ID as! String
        let db:DatabaseReference = Database.database().reference().child("comments/\(major)/\(course)/\(rootPostID)")
        db.observeSingleEvent(of: .value, with: { (DataSnapshot) in 
            var comments:[Comment] = []
            for item in DataSnapshot.children {
                let comment = item as! DataSnapshot
                let dic = comment.value as! NSDictionary
                let creator:String = dic[Comments.CREATOR_ID] as! String
                let creatorUsername:String = dic[Comments.CREATOR_USERNAME] as! String
                let content:String = dic[Comments.CONTENT] as! String
                let isPrivate:Bool = dic[Comments.IS_PRIVATE] as! Bool
                let isResponse:Bool = dic[Comments.IS_RESPONSE] as! Bool
                let respondeeID:String = dic[Comments.RESPONDEE_ID] as! String
                let creationTime:Date? = self.formatter.date(from: dic[Comments.CREATION_TIME] as! String)
                let ID:String = comment.key
                let fetchedComment:Comment = Comment(creator:creator,
                                                     creatorUsername:creatorUsername,
                                                     content:content,
                                                     isPrivate:isPrivate,
                                                     rootPost:self.rootPost!,
                                                     isResponse:isResponse,
                                                     respondeeID:respondeeID,
                                                     creationTime:creationTime,
                                                     ID:ID)
                comments.append(fetchedComment)
            }
            self.comments = comments
            self.scrollView.setNeedsDisplay()
            self.setUpStack()
        })
    }
    
    
    //refresh control 
    let refreshControl: UIRefreshControl = {
        let rfc = UIRefreshControl();
        rfc.addTarget(self, action: #selector(refreshPost), for: .valueChanged)
        return rfc
    }()

    // Create scroll view
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        // scroll.backgroundColor = UIColor.green
        return scroll
    }()
    
    // Create the view inside the scroll view
    let insideScrollView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor.cyan
        return view
    }()
    
    // Create the TextView for the post
    lazy var postText: UITextView = {
        let label = UITextView.createPostComment(textContent: self.rootPost!.content, username: self.rootPost!.creatorUsername, creationTime:self.rootPost!.creationTime)
        return label
    }()
    
    // Create the post title
    lazy var postTitle: UILabel = {
        let label = UILabel();
        label.text = (self.rootPost?.title)!
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
    
    lazy var courseTitle: UILabel = {
        let label = UILabel();
        label.text = (self.rootPost?.major)! + " " + (self.rootPost?.course)!
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
    
    
    
    // create the "Replies:" label
    let replyLabel: UILabel = {
        let label = UILabel();
        label.text = "Replies:"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.left
        label.sizeToFit()
        return label
    }()
    
    // create the "Reply" button
    let replyButton: UIButton = {
        let button = UIButton(type: .system);
        button.setTitle("Reply", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = APP_BLUE
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.isEnabled = true
        button.addTarget(self, action: #selector(replyAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setUpStack() {
        // set scrollView delegate to the view and add it to the view
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.anchor(left: view.leftAnchor, leftPadding: 5, right: view.rightAnchor, rightPadding: -5, top: view.topAnchor, topPadding: 110, bottom: view.bottomAnchor, bottomPadding: -150, width: 0, height: 0)
        
        // add insideScrollView to scrollView and add anchors
        scrollView.addSubview(insideScrollView)
        insideScrollView.anchor(left: scrollView.leftAnchor, leftPadding: 0, right: scrollView.rightAnchor, rightPadding: 0, top: scrollView.topAnchor, topPadding: 0, bottom: scrollView.bottomAnchor, bottomPadding: 0, width: scrollView.bounds.size.width, height: 0)
        
        // sample posts
        
        var subviews = [postTitle, courseTitle, postText, replyLabel]
        for comment in self.comments{
            let label = UITextView.createPostComment(textContent: comment.content, username: comment.creatorUsername, creationTime:comment.creationTime)
            subviews.append(label)
        }
        let stackView = UIStackView(arrangedSubviews: subviews)
        
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        
        // add stack view to scroll view
        insideScrollView.addSubview(stackView)
        
        stackView.anchor(left: insideScrollView.leftAnchor, leftPadding: 10, right: insideScrollView.rightAnchor, rightPadding: -15, top: insideScrollView.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: view.bounds.size.width - 30, height: 0)
        stackView.centerXAnchor.constraint(equalTo: insideScrollView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: insideScrollView.centerYAnchor).isActive = true
    }

    fileprivate func setUpRefresh() {
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.addSubview(refreshControl)
    }
    
    // set constraints for reply button
    fileprivate func setUpReplyButton() {
        view.addSubview(replyButton)
        
        replyButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -70, width: 100, height: 40)
    }
    
    // set up reply button functionality
    @objc fileprivate func replyAction() {
        let replyController = ReplyController(rootPost:self.rootPost!, postController:self)
        self.navigationController?.pushViewController(replyController, animated: true)
    }

    func clear() {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        for subview in self.insideScrollView.subviews {
            subview.removeFromSuperview()
        }
        self.comments = []
    }
    //refreshes this page
    @objc func refreshPost() {        
        refreshControl.endRefreshing()
        self.clear()
        self.viewDidLoad()
    }

    
    // prevent scrollview from scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

// extend UITextView to contain a function that creates a Post/Comment
extension UITextView{
    static func createPostComment(textContent:String, username: String, creationTime:Date) -> UITextView {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let textView = UITextView();
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.text = username + ": \n" + textContent + "\n\n" + formatter.string(from: creationTime)
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = NSTextAlignment.left
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 0.0
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }
}
