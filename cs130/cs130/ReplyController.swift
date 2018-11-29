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
        
        view.backgroundColor = .white
        
        setUpReplyField()
        setUpSubmitButton()
        replyField.becomeFirstResponder()
    }
    
    // submit button
    let submitButton: UIButton = {
        let button = UIButton(type: .system);
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.isEnabled = true
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        return button
    }()
    
    // reply textfield
    let replyField: UITextView = {
        let reply = UITextView();
        reply.backgroundColor = UIColor(white: 0, alpha: 0.04)
        reply.textColor = .black
        reply.layer.cornerRadius = 5
        reply.font = UIFont.systemFont(ofSize: 16)
        return reply
    }()
    
    // set constraints for submit button
    fileprivate func setUpSubmitButton() {
        view.addSubview(submitButton)
        submitButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: replyField.bottomAnchor, topPadding: 20, bottom: view.bottomAnchor, bottomPadding: -375, width: 0, height: 0)
    }
    
    // set constraints for replyfield
    fileprivate func setUpReplyField() {
        view.addSubview(replyField)
        replyField.anchor(left: view.leftAnchor, leftPadding: 15, right: view.rightAnchor, rightPadding: -15, top: view.topAnchor, topPadding: 100, bottom: view.bottomAnchor, bottomPadding: -450, width: 0, height: 0)
        
    }
    
    // TODO: setup submit button functionality
    @objc fileprivate func submitAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
