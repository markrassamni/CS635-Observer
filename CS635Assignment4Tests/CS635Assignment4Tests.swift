//
//  CS635Assignment4Tests.swift
//  CS635Assignment4Tests
//
//  Created by Mark Rassamni on 11/19/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import XCTest
@testable import CS635Assignment4

class CS635Assignment4Tests: XCTestCase {

    let testURL = "https://dzone.com/articles/6-reasons-why-you-should-go-for-a-static-website"
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let a = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
//        Factory().getDateModified(of: a)
    }
    
    func testReturningADate(){
        let expectation = self.expectation(description: "Date Header")
        var date: String?
        Factory().getDateModified(of: testURL) { (response) in
            date = response
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(date)
    }
    
    func testConsoleOutput(){
        let factory = Factory()
        let subject = factory.createStringPublishSubject()
        let _ = factory.createConsoleSubscriber(subject: subject)
        subject.onNext("Date 1")
        subject.onNext("Date 2")
        
    }
    
    func testObserve(){
        Factory().testObserve(url: testURL)
    }
    
    func testDateNoChange(){
        // make 2 calls that return the same date, check for no output
    }
    
    func testChangingDate(){
        // make 2 calls that date changes, check for appropriate output
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
