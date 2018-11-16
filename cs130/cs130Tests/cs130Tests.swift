//
//  cs130Tests.swift
//  cs130Tests
//
//  Created by Ram Yadav on 11/2/18.
//  Copyright © 2018 Ram Yadav. All rights reserved.
//

import XCTest
@testable import cs130

class cs130Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testUser() {
        // Check if user id is correct
        XCTAssert(appUser.id == "TESTUSER")
        sleep(50)
        // This user should be enrolled in 5 courses right now
        XCTAssert(appUser.courses.count == 5)
        // This first course is CS130
        XCTAssert(appUser.courses[0].0 == "Computer Science" && appUser.courses[0].1 == "130")
    }
    
    func testCourseEnrolling() {
        let VC = CourseTableViewController()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
