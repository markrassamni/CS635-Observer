//
//  Factory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import MessageUI

class Factory {
    
    // TODO: Create factory protocol, pass it into file parser etc. This is base factory, create new mockfact that returns values instead of performing mail sms etc
    
    private init(){}
    static let instance = Factory()
    
    func createWebPageSubject(url: String, dateModified: String) -> WebPageSubject{
        return WebPageSubject(subject: createPublishSubject(), url: url, dateModified: dateModified)
    }
    
    func createPublishSubject() -> PublishSubject<String>{
        return PublishSubject<String>()
    }
    
    func createEmailSubscriber(forSubject subject: WebPageSubject, sendTo emailAddress: String, sender: SenderProtocol){
        let _ = subject.subject.subscribe(onNext: { (message) in
            let mailVC = self.createEmail(to: emailAddress, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendMail(mailVC: mailVC)
            // TODO: Call sender. send email - sender is new protocol can be mocked?
            // if cannot get prot to work send here to UpdateVC and only use create for testing
        }, onError: { (error) in
            let mailVC = self.createEmail(to: emailAddress, message: error.localizedDescription)
            let _ = sender.sendMail(mailVC: mailVC)
        }, onCompleted: {
            let mailVC = self.createEmail(to: emailAddress, message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendMail(mailVC: mailVC)
        })
    }
    
    func createSMSSubscriber(forSubject subject: WebPageSubject, sendTo number: String, carrier: Carrier, sender: SenderProtocol) {
        let _ = subject.subject.subscribe(onNext: { (message) in
            let textVC = self.createText(to: number, carrier: carrier, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendText(textVC: textVC)
        }, onError: { (error) in
            let textVC = self.createText(to: number, carrier: carrier, message: error.localizedDescription)
            let _ = sender.sendText(textVC: textVC)
        }, onCompleted: {
            let textVC = self.createText(to: number, carrier: carrier, message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendText(textVC: textVC)
        })
    }
    
    func createConsoleSubscriber(forSubject subject: WebPageSubject, sender: SenderProtocol){
        let _ = subject.subject.subscribe(onNext: { (message) in
            let output = self.createConsoleOutput(message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendConsole(output: output)
        }, onError: { (error) in
            let output = self.createConsoleOutput(message: error.localizedDescription)
            let _ = sender.sendConsole(output: output)
        }, onCompleted: {
            let output = self.createConsoleOutput(message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendConsole(output: output)
        })
    }
    
    func createEmail(to address: String, message: String) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.setToRecipients([address])
        mailVC.setMessageBody(message, isHTML: false)
        return mailVC
    }
    
    func createText(to number: String, carrier: Carrier, message: String) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        let address = "\(number)@\(carrier.address)"
        mailVC.setToRecipients([address])
        mailVC.setMessageBody(message, isHTML: false)
        return mailVC
    }
    
    func createConsoleOutput(message: String) -> String {
        return message
    }
}
