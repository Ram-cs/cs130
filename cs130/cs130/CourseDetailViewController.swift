//
//  CourseDetailViewController.swift
//  cs130
//
//  Created by Runjia Li on 11/11/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

// This viewcontroller displays details of a class
import UIKit

class CourseDetailViewController: UIViewController {
    var course: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self.navigationController?.navigationBar.barTintColor = APP_BLUE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        // self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.displayCourse()
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
    
    // Just a placeholder right now, should be a table of course information
    let info: UIView =  {
        let newView = UIView()
        newView.translatesAutoresizingMaskIntoConstraints = false
        newView.backgroundColor = UIColor.white
        newView.frame.size.height = 300
        return newView
    }()
    
    // Enroll button to be l
    let enroll: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 181, green: 252, blue: 161)
        button.setTitle("ENROLL", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = button.titleLabel?.font.withSize(30)
        return button
    } ()
    
    func displayCourse() {
        self.courseTitle.text = self.course?.attributes["title"]! as! String
        
        let pageStack = UIStackView(arrangedSubviews: [self.courseTitle, self.info])
        pageStack.axis = .vertical
        pageStack.distribution = .fillProportionally
        pageStack.alignment = .fill
        pageStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageStack)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v" : pageStack]))
        
    }
}
