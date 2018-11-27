//
//  CS635Assignment4Tests.swift
//  CS635Assignment4Tests
//
//  Created by Mark Rassamni on 11/19/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import XCTest
import RxSwift

@testable import CS635Assignment4

class CS635Assignment4Tests: XCTestCase {

    let testURL = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
    let testFile1 = "test1.txt"
    let testFile2 = "test2.txt"
    
    let fileParser = FileParser()
    let mockOutput = MockOutput()
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
        let successfulRead = fileParser.readFile(file: testFile1, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
            for subject in subjects {
                subject.checkForUpdates(connectionHandler: self.mockConnection, updated: nil)
            }
        }
        XCTAssertTrue(successfulRead)
    }
    
    func testSubjectCount(){
        var subjectsFound: Int?
        let _ = fileParser.readFile(file: testFile1, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
            subjectsFound = subjects.count
        }
        XCTAssertEqual(subjectsFound, 2)
    }
    
    func testMockDateChanges(){
        let mockConnection = MockConnectionHandler(mockDates: createIncrementingMockDates(count: 2))
        var subjectCount: Int?
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
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
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
            subject = subjects.first
        }
        XCTAssertTrue(success)
        XCTAssertNil(subject)
    }
    
    func testErrorNoNewMockDate(){
        let mockConnection = MockConnectionHandler(mockDates: createIncrementingMockDates(count: 1))
        var subject: WebPageSubject?
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
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
        let success = fileParser.readFile(file: testFile2, connectionHandler: mockConnection, output: mockOutput) { (subjects) in
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
        let subject = SubjectFactory.instance.createWebPageSubject(url: testURL, dateModified: "date")
        subject.createConsoleSubscriber(output: mockOutput)
        subject.subject.onNext("newDate")
        guard let output = mockOutput.getConsoleOutput() else {
            XCTAssertTrue(false)
            return
        }
        let expected = "Web page \(subject.url) has been updated at \(subject.dateModified)"
        XCTAssertEqual(output, expected)
    }
    
    func testGetMockMail(){
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
        let mail = MailViewController()
        mail.setSubject("Subject")
        mail.setToRecipients(["test@me.com"])
        mail.setMessageBody("Body", isHTML: false)
        mockOutput.sendMail(mailVC: mail)
        let mailReturned = mockOutput.getMailVC()
        XCTAssertEqual(mail, mailReturned)
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
    }
    
    func testGetMockText(){
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
        let text = MailViewController()
        text.setSubject("Subject")
        text.setToRecipients(["test@me.com"])
        text.setMessageBody("Body", isHTML: false)
        mockOutput.sendText(textVC: text)
        let textReturned = mockOutput.getTextVC()
        XCTAssertEqual(text, textReturned)
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
    }
    
    func testGetMockPrint(){
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
        let output = "Test"
        mockOutput.sendConsole(output: output)
        let outputReturned = mockOutput.getConsoleOutput()
        XCTAssertEqual(output, outputReturned)
        XCTAssertNil(mockOutput.getMailVC())
        XCTAssertNil(mockOutput.getTextVC())
        XCTAssertNil(mockOutput.getConsoleOutput())
    }
}


