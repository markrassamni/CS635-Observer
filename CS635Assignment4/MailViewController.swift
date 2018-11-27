//
//  MailViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/27/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

/// Class needed to compare MFMailComposeViewControllers in testing
class MailViewController: MFMailComposeViewController {
    
    private var subject: String?
    private var recipients: [String]?
    private var body: String?
    private var isHTML: Bool?
    
    override func setSubject(_ subject: String) {
        super.setSubject(subject)
        self.subject = subject
    }
    
    override func setToRecipients(_ toRecipients: [String]?) {
        super.setToRecipients(toRecipients)
        self.recipients = toRecipients
    }
    
    override func setMessageBody(_ body: String, isHTML: Bool) {
        super.setMessageBody(body, isHTML: isHTML)
        self.body = body
        self.isHTML = isHTML
    }
    
    override func copy() -> Any {
        let copy = MailViewController()
        if let body = body, let isHTML = isHTML {
            copy.setMessageBody(body, isHTML: isHTML)
        }
        if let subject = subject {
            copy.setSubject(subject)
        }
        copy.setToRecipients(recipients)
        return copy
    }
    
    static func ==(lhs: MailViewController, rhs: MailViewController) -> Bool {
        return lhs.subject == rhs.subject && lhs.recipients == rhs.recipients && lhs.body == rhs.body && lhs.isHTML == rhs.isHTML
    }
}
