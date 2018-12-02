//
//  CreatePostController.swift
//  cs130
//
//  Created by Henry Cao on 11/15/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit

import Firebase

class CreatePostController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let personalBoard:PersonalBoardController?
    var majorOptions = [String]()
    var courseOptions = [String]()
    
    /// Initializes a CreatePostController
    /// - parameters:
    ///     - personalBoard: personalBoard object that this is attached to
    /// - returns: a new CreatePostController object
    init(personalBoard:PersonalBoardController) {
        self.personalBoard = personalBoard
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.personalBoard = nil
        super.init(coder:aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Create Post"
        view.backgroundColor = PANEL_GRAY
        
        let backButtonItem = navigationItem.backBarButtonItem
        navigationItem.leftBarButtonItem = backButtonItem

        createOptions()

        
        let majorPickerView = UIPickerView()
        let coursePickerView = UIPickerView()
        
        majorPickerView.delegate = self
        coursePickerView.delegate = self
        
        majorPickerView.tag = 1
        coursePickerView.tag = 2
        
        majorName.inputView = majorPickerView
        courseName.inputView = coursePickerView
        
        createFields()
        // createPostButton()
        // addErrorLabel()
    }
    
    fileprivate func createOptions() {
        for course in LoadUserController.singletonUser!.courses {
            if(!majorOptions.contains(course.0))  {
                majorOptions.append(course.0)
            }
            if(!courseOptions.contains(course.1)) {
                courseOptions.append(course.1)
            }
        }
    }
    
    fileprivate func createFields() {
        let stackView = UIStackView(arrangedSubviews: [postName, majorName, courseName, bodyLabel, postBody, errorLabel, userType, submitButton])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        postBody.heightAnchor.constraint(equalToConstant: 300).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : stackView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-120-[v]-160-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : stackView]))
        
        // stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 0)
        // stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func createPostButton(){
        view.addSubview(submitButton)
        submitButton.anchor(left: view.leftAnchor, leftPadding: 24, right: view.rightAnchor, rightPadding: -24, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -70, width: 100, height: 40)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return majorOptions.count
        }
        
        if pickerView.tag == 2{
            return courseOptions.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return majorOptions[row]
        }
        
        if pickerView.tag == 2{
            return courseOptions[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            majorName.text = majorOptions[row]
        }
        
        if pickerView.tag == 2{
            courseName.text = courseOptions[row]
        }
        
    }
    
    let postName: UITextField = {
        let button = UITextField();
        button.backgroundColor = .white
        button.textColor = .black
        button.attributedPlaceholder = NSAttributedString(string: "Post Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        button.borderStyle = .roundedRect
        button.font = UIFont.systemFont(ofSize: 16)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var majorName: UITextField = {
        let button = UITextField();
        button.backgroundColor = .white
        button.textColor = .black
        button.attributedPlaceholder = NSAttributedString(string: "Major", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        button.borderStyle = .roundedRect
        button.font = UIFont.systemFont(ofSize: 16)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    var courseName: UITextField = {
        let button = UITextField();
        button.backgroundColor = .white
        button.textColor = .black
        button.attributedPlaceholder = NSAttributedString(string: "Course Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        button.borderStyle = .roundedRect
        button.font = UIFont.systemFont(ofSize: 16)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Type your post here"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let postBody: UITextView = {
        let body = UITextView();
        // body.text = "Sample Post Body"
        body.backgroundColor = UIColor.white
        body.textColor = UIColor.black
        func textViewPlaceHolder(_ body: UITextView) {
            if body.textColor == UIColor.lightGray{
                body.text=nil
                body.textColor = UIColor.black
            }
        }
        func textViewDidNotEdit(_ body: UITextView){
            if body.text.isEmpty{
                body.text = "Sample Post Body"
                body.textColor = UIColor.lightGray
            }
        }
        body.font = UIFont.systemFont(ofSize: 16)
        body.sizeToFit()
        return body
    }()
    

    let userType: UISegmentedControl = {
        let user = UISegmentedControl()
        user.insertSegment(withTitle: "Student", at: 0, animated: true)
        user.insertSegment(withTitle: "Tutor", at: 1, animated: true)
        user.selectedSegmentIndex = 0
        return user
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Post", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = APP_BLUE
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = true
        button.addTarget(self, action: #selector(submitHandle), for: .touchUpInside)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        // label.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175) //render background color
        label.textColor = .red
        label.text = "Please fill out the form"
        label.alpha = 0.0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    func addErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -310, width: 0, height: 40)
    }
    
    @objc func submitHandle() {
        guard let major = majorName.text, major.count > 0 else { self.errorLabel.alpha = 1.0; return }
        guard let course = courseName.text, course.count > 0 else { self.errorLabel.alpha = 1.0; return }
        guard let title = postName.text, title.count > 0 else { self.errorLabel.alpha = 1.0; return }
        guard let body = postBody.text, body.count > 0 else { self.errorLabel.alpha = 1.0; return }
        
        var type = false
        if(userType.titleForSegment(at: userType.selectedSegmentIndex) == "Tutor"){
            type = true
        }
        if((Auth.auth().currentUser?.uid) != nil) {
            let userID : String = (Auth.auth().currentUser?.uid)!
            let newPost = Post(creator: userID,
                               creatorUsername:LoadUserController.singletonUser!.username,
                title: title, 
                content: body, 
                major: major, 
                course: course, 
                isTutorSearch: type, 
                creationTime: nil, 
                ID: nil )
            let db = DatabaseAddController()
            db.addPost(post: newPost)
        }
        self.navigationController?.popViewController(animated:true)
        self.personalBoard!.refreshBoard()
    }
}
