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
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Create Reply"
        view.backgroundColor = .white
        let backButton = UIButton(type: .system);
        backButton.setTitle("Back", for: .normal)
        backButton.clipsToBounds = true
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.titleLabel?.font=UIFont.systemFont(ofSize: 12)
        backButton.isEnabled = true
        let backButtonItem = UIBarButtonItem.init(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        // setup submit button
        //let submit = UIButton(type: .system);
        //submit.setTitle("Submit", for: .normal)
        //submit.isEnabled = true
        //submit.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        //let submitItem = UIBarButtonItem.init(customView: submit)
        //navigationItem.rightBarButtonItem = submitItem
        
        //view.backgroundColor = .white
        


        setUpReplyField()
        createPostButton()
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


    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Comment", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        button.addTarget(self, action: #selector(submitHandle), for: .touchUpInside)
        return button
    }()

    fileprivate func createPostButton(){
        view.addSubview(submitButton)
        submitButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -70, width: 100, height: 40)
    }
    
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
