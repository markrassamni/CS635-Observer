//
//  CS635Assignment4Tests.swift
//  CS635Assignment4Tests
//
//  Created by Mark Rassamni on 11/19/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
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
        super.tearDown()
    }
    
    func createIncrementingMockDates(count: Int) -> [String]{
        var mockDates = [String]()
        for index in 0..<count {
            mockDates.append("Date\(index)")
        }
        return mockDates
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
        let mockConnection = MockConnectionHandler(mockDates: ["Date", "Date", "Date1"])
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
        var didUpdate: Bool?
        subject?.checkForUpdates(connectionHandler: mockConnection, updated: { (updated) in
            didUpdate = updated
        })
        XCTAssertFalse(didUpdate!)
        XCTAssertEqual(subject?.dateModified, "Date")
        didUpdate = nil
        subject?.checkForUpdates(connectionHandler: mockConnection, updated: { (updated) in
            didUpdate = updated
        })
        XCTAssertTrue(didUpdate!)
        XCTAssertEqual(subject?.dateModified, "Date1")
    }
    
    func testConsoleOutput(){
        let subject = Factory.instance.createWebPageSubject(url: testURL, dateModified: "date")
    }
    
    func testSubscriber(){
        let subject = Factory.instance.createWebPageSubject(url: testURL, dateModified: "date")
        Factory.instance.createEmailSubscriber(forSubject: subject, sendTo: "me")
        //create like this for mock:
        
        subject.subject.subscribe(onNext: { (date) in
            
        }, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        
        // TODO: Factory and mock factory. createEmailSubscriber on Factory protocol, calls correct method.
        
    }
    
//    func testConsoleOutput(){
//        let factory = Factory()
//        let subject = factory.createStringPublishSubject()
//        let _ = factory.createConsoleSubscriber(subject: subject)
//        subject.onNext("Date 1")
//        subject.onNext("Date 2")
//
//    }
    
    // TODO: Mock WebPageSubject class - returns true/f for updates?
    
    // TODO: Create test that instead of read file is passed a url etc and does everything with my given parameters

    // TODO: Factory for connections just returns a data request, caller uses request.responseString
    // Override response string in mock to return my dates
    
    
    // TODO: Init Subject calls get Date. Subject subject.getDate only calls onNext if subject.date was already initialized (not nil)

}
