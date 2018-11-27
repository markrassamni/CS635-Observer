//
//  MockSender.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

class MockSender: SenderProtocol {
    // TODO: Remove mock and protocol? Dont need return vals like this
    private var mailVC: MFMailComposeViewController?
    private var textVC: MFMailComposeViewController?
    private var consoleOutput: String?
    
    func sendMail(mailVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        self.mailVC = mailVC
        return mailVC
    }
    
    func sendText(textVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        self.textVC = textVC
        return textVC
    }
    
    func sendConsole(output: String) -> String? {
        self.consoleOutput = output
        return output
    }
    
    func getMailVC() -> MFMailComposeViewController? {
        let mail = mailVC?.copy() as? MFMailComposeViewController
        mailVC = nil
        return mail
    }
    
    func getTextVC() -> MFMailComposeViewController? {
        let text = textVC?.copy() as? MFMailComposeViewController
        textVC = nil
        return text
    }
    
    func getConsoleOutput() -> String? {
        let output = consoleOutput
        consoleOutput = nil
        return output
    }
}
