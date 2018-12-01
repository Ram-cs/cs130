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
        
    func loginTestCase() {
        let app = XCUIApplication()
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Login"].exists)
    }
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

}
