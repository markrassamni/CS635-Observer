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
    let testFile1 = "test1.txt"
    let testFile2 = "test2.txt"
    
    let fileParser = FileParser()
    var mockConnection: MockConnectionHandler!
    
    override func setUp() {
        super.setUp()
        mockConnection = MockConnectionHandler(mockDates: createIncrementingMockDates(count: 50))
    }

    override func tearDown() {
        
    }
    
    func createIncrementingMockDates(count: Int) -> [String]{
        var mockDates = [String]()
        for index in 0..<count {
            mockDates.append("Date\(index)")
        }
        return mockDates
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let a = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
//        Factory().getDateModified(of: a)
    }
    
    func testReadFileSuccessfully(){
        let successfulRead = fileParser.readFile(file: testFile1, connectionHandler: mockConnection) { (subjects) in
            for subject in subjects {
                subject.checkForUpdates(connectionHandler: self.mockConnection, updated: nil)
            }
        }
        XCTAssertTrue(successfulRead)
    }
    
    func testSubjectCount(){
        var subjectsFound: Int?
        let _ = fileParser.readFile(file: testFile1, connectionHandler: mockConnection) { (subjects) in
            subjectsFound = subjects.count
        }
        XCTAssertEqual(subjectsFound, 2)
    }
    
    func testMockDateChanges(){
        let mockConnection = MockConnectionHandler(mockDates: createIncrementingMockDates(count: 2))
        var subjectCount: Int?
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection) { (subjects) in
            subjectCount = subjects.count
            subject = subjects.first
        }
        XCTAssertTrue(success)
        XCTAssertEqual(subjectCount, 1)
        XCTAssertNotNil(subject)
        XCTAssertEqual(subject?.dateModified, "Date0")
        var didUpdate: Bool?
        subject?.checkForUpdates(connectionHandler: mockConnection, updated: { (updated) in
            didUpdate = updated
        })
        XCTAssertEqual(subject?.dateModified, "Date1")
        XCTAssertTrue(didUpdate!)
        didUpdate = nil
        subject?.checkForUpdates(connectionHandler: mockConnection, updated: { (updated) in
            didUpdate = updated
        })
        XCTAssertFalse(didUpdate!)
        XCTAssertEqual(subject?.dateModified, "Date1")
    }
    
    func testNoDateNilSubject(){
        let mockConnection = MockConnectionHandler(mockDates: [String]())
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection) { (subjects) in
            subject = subjects.first
        }
        XCTAssertTrue(success)
        XCTAssertNil(subject)
    }
    
    func testErrorNoNewMockDate(){
        let mockConnection = MockConnectionHandler(mockDates: createIncrementingMockDates(count: 1))
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection) { (subjects) in
            subject = subjects.first
        }
        XCTAssertTrue(success)
        XCTAssertNotNil(subject)
        var error: Error?
        var date: String?
        mockConnection.getDateModified(forSubject: subject!) { (errorResponse, dateResponse) in
            error = errorResponse
            date = dateResponse
        }
        XCTAssertNotNil(error)
        XCTAssertNil(date)
        XCTAssertEqual(error?.localizedDescription, DateError.noMockDates.localizedDescription)
    }
    
    func testMockDateStaysSame(){
        // TODO: Not completed 
        let mockConnection = MockConnectionHandler(mockDates: ["Date", "Date"])
        var subjectCount: Int?
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection) { (subjects) in
            subjectCount = subjects.count
            subject = subjects.first
        }
        XCTAssertTrue(success)
        XCTAssertEqual(subjectCount, 1)
        XCTAssertNotNil(subject)
        XCTAssertEqual(subject?.dateModified, "Date")
//        subject?.checkForUpdates(connectionHandler: mockConnection)
        XCTAssertEqual(subject?.dateModified, "Date")
        var error: Error?
        var date: String?
        mockConnection.getDateModified(forSubject: subject!) { (errorResponse, dateResponse) in
            error = errorResponse
            date = dateResponse
        }
        XCTAssertNotNil(error)
        XCTAssertNil(date)
        XCTAssertEqual(error?.localizedDescription, DateError.noMockDates.localizedDescription)
    }
    
//    func testConsoleOutput(){
//        let factory = Factory()
//        let subject = factory.createStringPublishSubject()
//        let _ = factory.createConsoleSubscriber(subject: subject)
//        subject.onNext("Date 1")
//        subject.onNext("Date 2")
//
//    }
    
    func testDateNoChange(){
        // make 2 calls that return the same date, check for no output
    }
    
    func testChangingDate(){
        // make 2 calls that date changes, check for appropriate output
    }
    
    // TODO: Mock WebPageSubject class - returns true/f for updates?
    
    // TODO: Create test that instead of read file is passed a url etc and does everything with my given parameters

    // TODO: Factory for connections just returns a data request, caller uses request.responseString
    // Override response string in mock to return my dates
    
    
    // TODO: Init Subject calls get Date. Subject subject.getDate only calls onNext if subject.date was already initialized (not nil)

}
