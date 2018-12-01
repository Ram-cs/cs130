//
//  AccountController.swift
//  cs130
//
//  Created by Henry Cao on 11/15/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AccountController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var ref: DatabaseReference?
    var table = UITableView()
    var courses = [Course]()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Account"
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white

//        let backButton = UIButton(type: .system);
//        backButton.setTitle("Back", for: .normal)
//        backButton.clipsToBounds = true
//        backButton.setTitleColor(UIColor.white, for: .normal)
//        backButton.titleLabel?.font=UIFont.systemFont(ofSize: 12)
//        backButton.isEnabled = true
//        let backButtonItem = UIBarButtonItem.init(customView: backButton)
//        navigationItem.leftBarButtonItem = backButtonItem

        getUsername()
        getCourses()
        display()
    }

    
    func getCourses() {
        let userCourses:[(String, String)] = LoadUserController.singletonUser!.courses
        for course in userCourses {
            fetchCourse(major: course.0, course: course.1)
        }
    }

    func fetchCourse(major: String, course: String) {
        let db:DatabaseReference = Database.database().reference().child(Majors.MAJORS).child(major).child(course)
        db.observeSingleEvent(of: .value, with: { (snapshot) in 
            let fetchedCourse:Course = Course(major:major, snapshot:snapshot)
            self.courses.append(fetchedCourse)
            self.preDisplay()
            print(self.courses.count)
            self.table.reloadData()
            })
    }

    private func preDisplay() {
        if(self.courses.count >= (LoadUserController.singletonUser!.courses.count)) {
            self.display()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //how many rows are displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    //display each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell
        let course = self.courses[indexPath.row]
        cell.setupContent(course: course)
        print("Displayed a cell")
        return cell
    }

    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    let nameField: UILabel = {
        let button = UILabel();
        button.text = "Sample name"
        button.textColor = UIColor.black
        button.isEnabled = true
        button.font = UIFont.boldSystemFont(ofSize: 16)
        button.textAlignment = NSTextAlignment.center
        return button
    }()
    
    let classTitle: UILabel = {
        let button = UILabel();
        button.text = "Class"
        button.textColor = UIColor.darkGray
        button.isEnabled = true
        button.font = UIFont.boldSystemFont(ofSize: 32)
        button.textAlignment = NSTextAlignment.center
        return button
    }()
        
    fileprivate func display(){
        nameField.text = username
        nameField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        classTitle.heightAnchor.constraint(equalToConstant: 200).isActive = true
        table.dataSource = self
        table.delegate = self
        table.register(CourseTableViewCell.self, forCellReuseIdentifier: "courseCell")
        table.tableFooterView = UIView(frame: .zero)
        table.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let pageStack = UIStackView(arrangedSubviews: [nameField, classTitle, table])
        pageStack.axis = .vertical
        pageStack.distribution = .fillProportionally
        pageStack.alignment = .fill
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageStack)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
    }
    
    fileprivate func getUsername(){
        self.username = LoadUserController.singletonUser!.username
    }
    
}

class UserTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let id: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = label.font.withSize(14.0)
        return label
    }()
    
    private func setupViews() {
        self.addSubview(self.name)
        self.addSubview(self.id)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.name]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.id]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v]-1-[v2]-15-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.name, "v2": self.id]))
    }
    
    func setupContent(course: Course) {
        self.name.text = course.major + " " + course.id + ": " + course.title
        self.id.text = course.professor + ", " + course.quarter + " " + String(course.year)
    }
}
