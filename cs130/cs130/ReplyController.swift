//
//  ReplyController.swift
//  cs130
//
//  Created by Andrew Yoon on 11/24/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

class ReplyController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create and setup navigation bar
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Reply"
        
        // setup submit button
        let submit = UIButton(type: .system);
        submit.setTitle("Submit", for: .normal)
        submit.isEnabled = true
        submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        let submitItem = UIBarButtonItem.init(customView: submit)
        navigationItem.rightBarButtonItem = submitItem
        
        view.backgroundColor = .white
        
        setUpReplyField()
        replyField.becomeFirstResponder()
    }
    

    // reply textfield
    let replyField: UITextView = {
        let reply = UITextView();
        reply.backgroundColor = UIColor(white: 0, alpha: 0.04)
        reply.textColor = .black
        reply.layer.cornerRadius = 5
        reply.font = UIFont.systemFont(ofSize: 16)
        return reply
    }()
    
    // set constraints for replyfield
    // TODO: make replyfield take into account keyboard size (current constraints only work on iphone)
    fileprivate func setUpReplyField() {
        view.addSubview(replyField)
        replyField.anchor(left: view.leftAnchor, leftPadding: 15, right: view.rightAnchor, rightPadding: -15, top: view.topAnchor, topPadding: 100, bottom: view.bottomAnchor, bottomPadding: -350, width: 0, height: 0)
        
    }
    
    // TODO: setup submit button functionality
    @objc fileprivate func submitAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
