//
//  PersonalBoardController.swift
//  cs130
//
//  Created by Andrew Yoon on 11/15/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

import Firebase

class PersonalBoardController: UIViewController, UIScrollViewDelegate {
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
        
        view.backgroundColor = .white
        
        setUpName()
        setUpCreatePost()
        setUplogOutButton()
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
        label.adjustsFontSizeToFitWidth = true
        return label
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
    
    // create scrollview container for posts
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = true
        // scroll.backgroundColor = UIColor.green
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    // create view to go inside to scrollview
    let insideScrollView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor.cyan
        return view
    }()
    
    // function that sets up the posts section
    fileprivate func setUpPost() {
        // set scrollView delegate to view
        scrollView.delegate = self
        
        // add scrollView and the view inside scrollView to the view and create anchors
        view.addSubview(scrollView)
        scrollView.addSubview(insideScrollView)
        
        scrollView.anchor(left: view.leftAnchor, leftPadding: 5, right: view.rightAnchor, rightPadding: -5, top: view.topAnchor, topPadding: 180, bottom: view.bottomAnchor, bottomPadding: -150, width: 0, height: 0)
        
        insideScrollView.anchor(left: scrollView.leftAnchor, leftPadding: 0, right: scrollView.rightAnchor, rightPadding: 0, top: scrollView.topAnchor, topPadding: 0, bottom: scrollView.bottomAnchor, bottomPadding: 0, width: scrollView.bounds.size.width, height: 0)
        
        // placeholder posts
        let button1 = UIButton.createPostButton(title:"Looking for tutor!")
        button1.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let button2 = UIButton.createPostButton(title: "Help me!")
        button2.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let button3 = UIButton.createPostButton(title: "Placeholder")
        button3.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        // create a stackview and add it to the scrollview and set anchors
        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 10
        
        scrollView.addSubview(stackView)
        
        stackView.anchor(left: insideScrollView.leftAnchor, leftPadding: 10, right: insideScrollView.rightAnchor, rightPadding: -15, top: insideScrollView.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: view.bounds.size.width - 30, height: 0)
        stackView.centerXAnchor.constraint(equalTo: insideScrollView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: insideScrollView.centerYAnchor).isActive = true
    }
    
    // set constraints for the name label
    fileprivate func setUpName() {
        view.addSubview(name)
        
        name.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: -12, top: view.topAnchor, topPadding: 120, bottom: nil, bottomPadding: 0, width: 0, height: 50)
    }
    
    // set constraints for the "Create Post" Button
    fileprivate func setUpCreatePost() {
        view.addSubview(CreatePostButton)

        CreatePostButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -70, width: 100, height: 40)
    }
    
    // setup logout button
    // TODO: button will work when merged into main
    private func setUplogOutButton() {
        let imageName = "gear.png"
        let image = UIImage(named: imageName)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    // set logoutbutton action
    @objc func handleLogOut() {
        // TODO: uncomment when merged into main
        
        /*let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (_) in
            do {
                try Auth.auth().signOut()
            } catch let signOutError {
                print("Problem signing Out:", signOutError)
            }
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }))
        alertController.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        present(alertController, animated: true, completion: nil)*/
    }
    
    // button action function. use sender.tag to specify the action
    @objc fileprivate func buttonAction(sender: UIButton) {
        let postController = PostController()
        if (sender.tag == 1) {
            self.navigationController?.pushViewController(postController, animated: true)
        }
    }
    
    // function that stops ScrollView from scrolling horizontally
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}

// extension of UIButton class to create a post button
// use button.tag for the buttonAction
extension UIButton {
    static func createPostButton(title:String) -> UIButton {
        let button = UIButton(type: .system);
        button.tag = 1
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.isEnabled = true
        return button
    }
}