//
//  TestMailViewController.swift
//  CS635Assignment4Tests
//
//  Created by Mark Rassamni on 11/27/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit
@testable import CS635Assignment4

// These tests must be ran on a real device and ran from the active view controller class.
// Target must be the actual project instead of Tests project: View > Inspectors > Show File Inspector.
// Replace XCTAssert with assert to use without unit test framework.
// If app runs successfully, tests pass. If app crashes, tests fail.
class TestMailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testEmailOutput()
        testTextOutput()
    }
    
    func testEmailOutput(){
        let url = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
        let mockOutput = MockOutput()
        let subject = SubjectFactory.instance.createWebPageSubject(url: url, dateModified: "date")
        let recipient = "test"
        subject.createEmailSubscriber(sendTo: recipient, output: mockOutput)
        subject.subject.onNext("newDate")
        guard let mailVC = mockOutput.getMailVC() else {
            //  XCTAssertTrue(false)
            assert(false)
            return
        }
        let expected = MailViewController()
        expected.setSubject("Webpage updated")
        expected.setToRecipients([recipient])
        let message = "Web page \(subject.url) has been updated at \(subject.dateModified)"
        expected.setMessageBody(message, isHTML: false)
        let areEqual = mailVC == expected
        //  XCTAssertTrue(areEqual)
        assert(areEqual)
    }
    
    func testTextOutput(){
        let url = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
        let mockOutput = MockOutput()
        let subject = SubjectFactory.instance.createWebPageSubject(url: url, dateModified: "date")
        subject.createSMSSubscriber(sendTo: "test", carrier: Carrier(name: "att")!, output: mockOutput)
        subject.subject.onNext("newDate")
        guard let textVC = mockOutput.getTextVC() else {
            //  XCTAssertTrue(false)
            assert(false)
            return
        }
        let expected = MailViewController()
        expected.setSubject("Webpage updated")
        expected.setToRecipients(["test@mms.att.net"])
        let message = "Web page \(subject.url) has been updated at \(subject.dateModified)"
        expected.setMessageBody(message, isHTML: false)
        let areEqual = expected == textVC
        //  XCTAssertTrue(areEqual)
        assert(areEqual)
    }
}
