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
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Account"
        view.backgroundColor = PANEL_GRAY
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.courses = [Course]()
        getInfo()
        getCourses()
        display()
    }

    fileprivate func getCourses() {
        let userCourses:[(String, String)] = LoadUserController.singletonUser!.courses
        for course in userCourses {
            fetchCourse(major: course.0, course: course.1)
        }
    }

    fileprivate func fetchCourse(major: String, course: String) {
        let db:DatabaseReference = Database.database().reference().child(Majors.MAJORS).child(major).child(course)
        db.observeSingleEvent(of: .value, with: { (snapshot) in
            let fetchedCourse:Course = Course(major:major, snapshot:snapshot)
            self.courses.append(fetchedCourse)
            self.preDisplay()
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
    
    // how many rows are displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    // display each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseTableViewCell
        let course = self.courses[indexPath.row]
        cell.setupContent(course: course)
        return cell
    }

    //height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = self.courses[indexPath.row]
        let courseDetailViewController = CourseDetailViewController(course: course, accountController: self)
        self.navigationController?.pushViewController(courseDetailViewController, animated: true)
    }
    
    let nameField: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(25.0)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 8
        return label
    }()
    
    let emailField: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(20.0)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 8
        return label
    }()
    
    let classTitle: UILabel = {
        let button = UILabel();
        button.textColor = UIColor.darkGray
        button.text = "My courses"
        button.isEnabled = true
        button.font = UIFont.boldSystemFont(ofSize: 32)
        button.textAlignment = NSTextAlignment.center
        return button
    }()

    let allCourses: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = GREEN_COLOR
        button.setTitle("Add course", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        return button
    } ()
    
    @objc func gotoAllCourses(sender: UIButton) {
        let courseTableViewController = CourseTableViewController()
        courseTableViewController.accountController = self
        self.navigationController?.pushViewController(courseTableViewController, animated: true)
    }
    
    fileprivate func display(){
//        nameField.text = username
//        nameField.heightAnchor.constraint(equalToConstant: 200).isActive = true
        nameField.text = self.username
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailField.text = self.email
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let userInfoStack = UIStackView(arrangedSubviews: [nameField, emailField])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillEqually
        userInfoStack.alignment = .fill
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        classTitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        table.dataSource = self
        table.delegate = self
        table.register(CourseTableViewCell.self, forCellReuseIdentifier: "courseCell")
        table.tableFooterView = UIView(frame: .zero)
        table.heightAnchor.constraint(equalToConstant: 375).isActive = true
        
        allCourses.addTarget(self, action: #selector(self.gotoAllCourses), for: .touchUpInside)

        
        let pageStack = UIStackView(arrangedSubviews: [userInfoStack, classTitle, table, allCourses])
        pageStack.axis = .vertical
        pageStack.distribution = .fillProportionally
        pageStack.alignment = .fill
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageStack)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        let bottom = String(describing: UIScreen.main.bounds.height / 10)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[v]-" + bottom + "-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        
    }
    
    fileprivate func getInfo(){
        self.username = LoadUserController.singletonUser!.username
        self.email = LoadUserController.singletonUser!.email
    }
    
    /// Refreshes the table of enrolled courses
    func refresh() {
        self.viewDidLoad()
        self.table.reloadData()
    }
}
