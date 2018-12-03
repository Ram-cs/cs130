//
//  cs130UITests.swift
//  cs130UITests
//
//  Created by Ram Yadav on 11/30/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import XCTest

class cs130UITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    //Test cases for Account view controller
    //Adding cousrse
    func addCourse() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Computer Science CS130: Software Programming"]/*[[".cells.staticTexts[\"Computer Science CS130: Software Programming\"]",".staticTexts[\"Computer Science CS130: Software Programming\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let enrollButton = app.buttons["Enroll"]
        enrollButton.tap()
        
        let okayButton = app.alerts["Success"].buttons["Okay"]
        okayButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Computer Science CS131: Programming Languages"]/*[[".cells.staticTexts[\"Computer Science CS131: Programming Languages\"]",".staticTexts[\"Computer Science CS131: Programming Languages\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        enrollButton.tap()
        okayButton.tap()
    }
    
    //Test case for dropping cousrses
    func dropCourse() {
        let app = XCUIApplication()
        let dropCourseButton = app.buttons["Drop course"]
        dropCourseButton.tap()
        
        let okayButton = app.alerts["Success"].buttons["Okay"]
        okayButton.tap()
        app.navigationBars["cs130.CourseDetailView"].buttons["Account"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Engineering ENGR 183EW: Engineering and Society"]/*[[".cells.staticTexts[\"Engineering ENGR 183EW: Engineering and Society\"]",".staticTexts[\"Engineering ENGR 183EW: Engineering and Society\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        dropCourseButton.tap()
        okayButton.tap()
        
    }
    
    //Test case for when tap on the course
    func tapOnCourse() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Kim M., Fall 2018"]/*[[".cells.staticTexts[\"Kim M., Fall 2018\"]",".staticTexts[\"Kim M., Fall 2018\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let accountButton = app.navigationBars["cs130.CourseDetailView"].buttons["Account"]
        accountButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Computer Science CS131: Programming Languages"]/*[[".cells.staticTexts[\"Computer Science CS131: Programming Languages\"]",".staticTexts[\"Computer Science CS131: Programming Languages\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    //Test case for loinView controller
    //Test case to check the input field
    func loginTestCase() {
        let app = XCUIApplication()
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
    
    //Test case for SignUpViewController
    //Test case to check for the signUp input
    func signUpTestCase() {
        let app = XCUIApplication()
        XCTAssertTrue(app.buttons["Don't have an account? Sign Up."].exists)
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.textFields["Password"].exists)
        XCTAssertTrue(app.textFields["Confirm password"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    //Test case for personalBoard controller
    //Check for after signup and then logout
    func signUpAndLogOutTestCase() {
        let app = XCUIApplication()
        XCTAssertTrue(app.buttons["Don't have an account? Sign Up."].exists)
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.textFields["Password"].exists)
        XCTAssertTrue(app.textFields["Confirm password"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
        let gearButton = app.navigationBars["Personal Board"].buttons["gear"]
        XCTAssertTrue(gearButton.exists)
        
        let sheetsQuery = app.sheets
        XCTAssertTrue(sheetsQuery.buttons["Cancel"].exists)
        XCTAssertTrue(gearButton.exists)
        XCTAssertTrue(sheetsQuery.buttons["Log Out"].exists)
    }
    
    //Test case when signIn with credentials and after that logout
    func LoginAndSignOutTestCase() {
        let app = XCUIApplication()
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
        
        let gearButton = app.navigationBars["Personal Board"].buttons["gear"]
        XCTAssertTrue(gearButton.exists)
        
        let sheetsQuery = app.sheets
        XCTAssertTrue(sheetsQuery.buttons["Cancel"].exists)
        XCTAssertTrue(gearButton.exists)
        XCTAssertTrue(sheetsQuery.buttons["Log Out"].exists)
    }
    
    //Test case for SignUp useing loginView Controller and then SignUP
    func loginAndSignUpTestCase() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
        XCTAssertTrue( app.buttons["Don't have an account? Sign Up."].exists)
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(app.textFields["Username"].exists)
        XCTAssertTrue(app.textFields["Password"].exists)
        XCTAssertTrue(app.textFields["Confirm password"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    func testPersonalBoard() {
        
        let app = XCUIApplication()
        XCTAssertTrue(app.navigationBars["Personal Board"].buttons["Account"].exists)
        XCTAssertTrue(app.buttons["Create Post!"].exists)
        XCTAssertTrue(app.navigationBars["Create Post"].buttons["Personal Board"].exists)
    }
    
    func testPost() {
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["CS130_TutorSearch: Tutor for CS130"].tap()
        
        XCTAssertTrue(elementsQuery.staticTexts["TutorSearch: Tutor for CS130"].exists)
        XCTAssertTrue(elementsQuery.staticTexts["Computer Science CS130"].exists)
        XCTAssertTrue(elementsQuery.staticTexts["Replies:"].exists)
        XCTAssertTrue(app.buttons["Reply"].exists)
    }
    
    func testPostReply() {
        
        let app = XCUIApplication()
        app.scrollViews.otherElements.buttons["CS130_TutorSearch: Tutor for CS130"].tap()
        app.buttons["Reply"].tap()
        XCTAssertTrue(app.buttons["Post Comment"].exists)
    }
}
