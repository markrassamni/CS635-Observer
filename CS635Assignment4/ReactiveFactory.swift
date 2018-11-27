//
//  ReactiveFactory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class ReactiveFactory {
    // TODO: Make a subject factory and move subscribe back into subject
    private init(){}
    static let instance = ReactiveFactory()
    
    func createWebPageSubject(url: String, dateModified: String) -> WebPageSubject{
        return WebPageSubject(subject: createPublishSubject(), url: url, dateModified: dateModified)
    }
    
    func createPublishSubject() -> PublishSubject<String>{
        return PublishSubject<String>()
    }
    
    func createEmailSubscriber(forSubject subject: WebPageSubject, sendTo emailAddress: String, sender: SenderProtocol){
        let _ = subject.subject.subscribe(onNext: { (message) in
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendMail(mailVC: mailVC)
        }, onError: { (error) in
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: error.localizedDescription)
            let _ = sender.sendMail(mailVC: mailVC)
        }, onCompleted: {
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendMail(mailVC: mailVC)
        })
    }
    
    func createSMSSubscriber(forSubject subject: WebPageSubject, sendTo number: String, carrier: Carrier, sender: SenderProtocol) {
        let _ = subject.subject.subscribe(onNext: { (message) in
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendText(textVC: textVC)
        }, onError: { (error) in
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: error.localizedDescription)
            let _ = sender.sendText(textVC: textVC)
        }, onCompleted: {
            let textVC = OutputFactory.instance.createText(to: number, carrier: carrier, message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendText(textVC: textVC)
        })
    }
    
    func createConsoleSubscriber(forSubject subject: WebPageSubject, sender: SenderProtocol){
        let _ = subject.subject.subscribe(onNext: { (message) in
            let output = OutputFactory.instance.createConsoleOutput(message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            let _ = sender.sendConsole(output: output)
        }, onError: { (error) in
            let output = OutputFactory.instance.createConsoleOutput(message: error.localizedDescription)
            let _ = sender.sendConsole(output: output)
        }, onCompleted: {
            let output = OutputFactory.instance.createConsoleOutput(message: "You will no longer receive updates about \(subject.url)")
            let _ = sender.sendConsole(output: output)
        })
    }
}
