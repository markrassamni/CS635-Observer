//
//  MockSender.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class MockSender: SenderProtocol {
    // TODO: Remove mock and protocol? Dont need return vals like this
    private var mailVC: MailViewController?
    private var textVC: MailViewController?
    private var consoleOutput: String?
    
    func sendMail(mailVC: MailViewController) {
        self.mailVC = mailVC
    }
    
    func sendText(textVC: MailViewController){
        self.textVC = textVC
    }
    
    func sendConsole(output: String){
        self.consoleOutput = output
    }
    
    func getMailVC() -> MailViewController? {
        let mail = mailVC?.copy() as? MailViewController
        mailVC = nil
        return mail
    }
    
    func getTextVC() -> MailViewController? {
        let text = textVC?.copy() as? MailViewController
        textVC = nil
        return text
    }
    
    func getConsoleOutput() -> String? {
        let output = consoleOutput
        consoleOutput = nil
        return output
    }
}
