//
//  CourseDetailViewController.swift
//  cs130
//
//  Created by Runjia Li on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

// This viewcontroller displays details of a class
import UIKit
import FirebaseAuth

class CourseDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var course: Course?
    var infoTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.displayCourse()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.infoTable.dequeueReusableCell(withIdentifier: "cell") as! CourseInfoTableViewCell
        var field = ""
        var value = ""
        switch indexPath.row {
        case 0:
            field = "Course ID"
            value = ((self.course?.major)!) + " " + (self.course!.id)
        case 1:
            field = "Instructor"
            value = (self.course!.professor)
        case 2:
            field = "Quarter"
            value = (self.course!.quarter) + " " + String(self.course!.year)
        default:
            break
        }
        cell.fieldName.text = field
        cell.fieldValue.text = value
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    let courseTitle: UILabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(30.0)
        label.textColor = UIColor.gray
        label.backgroundColor = PANEL_GRAY
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let enroll: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 181, green: 252, blue: 161)
        button.setTitle("Enroll", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        return button
    } ()
    
    let userCnt = CourseStatsBox()
    let postCnt = CourseStatsBox()
    
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = PANEL_GRAY
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func enrollButtonPress(sender: UIButton) {
        PersonalBoardController.singletonUser?.addCourse(course: self.course!)
        self.viewDidLoad() // Refresh the page
    }
    
    /// Displays information of the current course
    func displayCourse() {
        // Set up the course title
        self.courseTitle.text = self.course!.title
        self.courseTitle.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // Register the info table
        self.infoTable.dataSource = self
        self.infoTable.delegate = self
        self.infoTable.register(CourseInfoTableViewCell.self, forCellReuseIdentifier: "cell")
        self.infoTable.tableFooterView = UIView(frame: .zero)
        self.infoTable.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        // Set up real-time stats display
        self.userCnt.number.text = String(self.course!.userCnt)
        self.userCnt.item.text = "Students"
        self.postCnt.number.text = String(self.course!.postCnt)
        self.postCnt.item.text = "Posts"
        
        // Substack containing stats
        let subStack = UIStackView(arrangedSubviews: [self.userCnt, self.postCnt])
        subStack.axis = .horizontal
        subStack.distribution = .fillEqually
        subStack.alignment = .fill
        subStack.translatesAutoresizingMaskIntoConstraints = false
        subStack.heightAnchor.constraint(equalToConstant: 120).isActive = true
        view.addSubview(subStack)
        
        // Set up enroll button action
        if (PersonalBoardController.singletonUser?.hasCourse(course: self.course!))! {
            self.enroll.backgroundColor = UIColor.gray
            self.enroll.setTitle("Enrolled", for: .normal)
        }
            
        else {
            self.enroll.addTarget(self, action: #selector(self.enrollButtonPress), for: .touchUpInside)
        }
        self.enroll.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // The empty view
        self.emptyView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Set up the stack view
        let pageStack = UIStackView(arrangedSubviews: [self.courseTitle, self.infoTable, subStack, self.enroll, self.emptyView])
        pageStack.axis = .vertical
        pageStack.distribution = .fillProportionally
        pageStack.alignment = .fill
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageStack)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
    }
}

class CourseInfoTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    let fieldName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fieldValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(self.fieldName)
        self.addSubview(self.fieldValue)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-[v2]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.fieldName, "v2" : self.fieldValue]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.fieldName]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.fieldValue]))
    }
}

class CourseStatsBox: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let number: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(30.0)
        label.textAlignment = .center
        return label
    } ()
    
    let item: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = label.font.withSize(20.0)
        label.textAlignment = .center
        return label
    } ()
    
    private func setupViews() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.number)
        self.addSubview(self.item)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v]-[v2]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.number, "v2" : self.item]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.number]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : self.item]))
    }
}
