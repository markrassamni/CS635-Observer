//
//  WebPageSubject.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class WebPageSubject {
    
    let subject: PublishSubject<String>
    let url: String
    var dateModified: String
    
    init(subject: PublishSubject<String>, url: String, dateModified: String) {
        self.subject = subject
        self.url = url
        self.dateModified = dateModified
    }
    
    func createEmailSubscriber(sendTo emailAddress: String, sender: SenderProtocol){
        let _ = subject.subscribe(onNext: { (message) in
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: "Web page \(self.url) has been updated at \(self.dateModified)")
            sender.sendMail(mailVC: mailVC)
        }, onError: { (error) in
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: error.localizedDescription)
            sender.sendMail(mailVC: mailVC)
        }, onCompleted: {
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: "You will no longer receive updates about \(self.url)")
            sender.sendMail(mailVC: mailVC)
        })
    }
    
    func createSMSSubscriber(sendTo number: String, carrier: Carrier, sender: SenderProtocol) {
        let _ = subject.subscribe(onNext: { (message) in
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: "Web page \(self.url) has been updated at \(self.dateModified)")
            sender.sendText(textVC: textVC)
        }, onError: { (error) in
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: error.localizedDescription)
            sender.sendText(textVC: textVC)
        }, onCompleted: {
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: "You will no longer receive updates about \(self.url)")
            sender.sendText(textVC: textVC)
        })
    }
    
    func createConsoleSubscriber(sender: SenderProtocol){
        let _ = subject.subscribe(onNext: { (message) in
            let output = OutputFactory.instance.createConsoleOutput(message: "Web page \(self.url) has been updated at \(self.dateModified)")
            sender.sendConsole(output: output)
        }, onError: { (error) in
            let output = OutputFactory.instance.createConsoleOutput(message: error.localizedDescription)
            sender.sendConsole(output: output)
        }, onCompleted: {
            let output = OutputFactory.instance.createConsoleOutput(message: "You will no longer receive updates about \(self.url)")
            sender.sendConsole(output: output)
        })
    }
    
    func checkForUpdates(connectionHandler: ConnectionProtocol, updated: ((Bool)->())?){
        connectionHandler.getDateModified(forSubject: self) { (error, date) in
            if let error = error {
                self.subject.onError(error)
                if updated != nil {
                    updated!(false)
                }
            } else if let date = date {
                if date != self.dateModified {
                    self.dateModified = date
                    self.subject.onNext(date)
                    if updated != nil {
                        updated!(true)
                    }
                } else {
                    if updated != nil {
                        updated!(false)
                    }
                }
            }
        }
    }
}
