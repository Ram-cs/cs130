//
//  PersonalBoardController.swift
//  cs130
//
//  Created by Andrew Yoon on 11/15/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

class PersonalBoardController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Personal Board"
        
        // TODO: Set up functionalities for the buttons
        let accountButton = UIButton(type: .system);
        accountButton.setTitle("Account", for: .normal)
        accountButton.clipsToBounds = true
        accountButton.setTitleColor(UIColor.white, for: .normal)
        accountButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        accountButton.isEnabled = true
        let accountButtonItem = UIBarButtonItem.init(customView: accountButton)
        navigationItem.leftBarButtonItem = accountButtonItem
        let logOutButton = UIButton(type: .system);
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.clipsToBounds = true
        logOutButton.setTitleColor(UIColor.white, for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        logOutButton.isEnabled = true
        let logOutButtonItem = UIBarButtonItem.init(customView: logOutButton)
        navigationItem.rightBarButtonItem = logOutButtonItem
        
        view.backgroundColor = .white
        
        setUpName()
        setUpCreatePost()
        setUpPost()
        
    }
    
    // name field
    let name: UILabel = {
        let label = UILabel();
        label.text = "Joe Bruin"
        label.textColor = UIColor.black
        label.isEnabled = true
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    // TODO: setup a class for this
    let PostButton: UIButton = {
        let button = UIButton(type: .system);
        button.setTitle("Placeholder", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = true
        return button
    }()
    
    // create the "Create Post" button
    let CreatePostButton: UIButton = {
        let button = UIButton(type: .system);
        button.setTitle("Create Post!", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.isEnabled = true
        return button
    }()
    
    fileprivate func setUpPost() {
        // placeholder "posts"
        let button1 = UIButton(type: .system);
        button1.setTitle("Placeholder", for: .normal)
        button1.layer.cornerRadius = 5
        button1.clipsToBounds = true
        button1.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button1.isEnabled = true

        let button2 = UIButton(type: .system);
        button2.setTitle("Placeholder", for: .normal)
        button2.layer.cornerRadius = 5
        button2.clipsToBounds = true
        button2.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button2.setTitleColor(UIColor.white, for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button2.isEnabled = true
        let button3 = UIButton(type: .system);
        button3.setTitle("Placeholder", for: .normal)
        button3.layer.cornerRadius = 5
        button3.clipsToBounds = true
        button3.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button3.setTitleColor(UIColor.white, for: .normal)
        button3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button3.isEnabled = true
        
        // not sure how the stack view will behave with large number of posts. will probably do something wonky
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    // set constratints for the name label
    fileprivate func setUpName() {
        view.addSubview(name)
        
        name.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: -12, top: view.topAnchor, topPadding: 120, bottom: nil, bottomPadding: 0, width: 0, height: 50)
    }
    
    // set constraints for the "Create Post" Button
    fileprivate func setUpCreatePost() {
        view.addSubview(CreatePostButton)

        CreatePostButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -70, width: 100, height: 40)
    }
}
