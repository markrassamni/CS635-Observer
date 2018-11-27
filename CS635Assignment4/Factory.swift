//
//  Factory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class Factory { // TODO: Rename to reactive factory
    
    // TODO: Create factory protocol, pass it into file parser etc. This is base factory, create new mockfact that returns values instead of performing mail sms etc
    
    private init(){}
    static let instance = Factory()
    
    var outputMethod: OutputProtocol
    
    func createWebPageSubject(output: OutputProtocol, url: String, dateModified: String) -> WebPageSubject{
        return WebPageSubject(subject: createPublishSubject(output: OutputProtocol), url: url, dateModified: dateModified)
    }
    
    func createPublishSubject(output: OutputProtocol) -> PublishSubject<OutputProtocol>{
        return PublishSubject<OutputProtocol>()
    }
    
    func test(){
        let sub = PublishSubject<Output>()
        sub.subscribe(onNext: { (output) in
            output.sendEmail(to: "a", message: "A")
        }, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        sub.onNext(<#T##element: Output##Output#>)
    }
    
    
    
    
    // TODO: Create output protocol, all subjects change to PublishSubject<OutputProtocol>(). Factory to create them needs to create Output or Mock Subjects
    // sub.subscribe(onNext: { (output) in ... output.sendMail etc
    
    // TODO: Call outputfacotry.getEmailVC.. then with it call outputpresenter.presentEmail(mailVC) -
    // mock will just return the mail, actual will present in updatesVC
    func createEmailSubscriber(forSubject subject: WebPageSubject, sendTo emailAddress: String){
        let _ = subject.subject.subscribe(onNext: { (output) in
            let mailVC = OutputFactory.instance.createEmail(to: emailAddress, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
            output.sendEmail(mailVC: mailVC)
//            let mail = OutputFactory.instance.createEmail(to: emailAddress, message: message)
//            self.outputMethod.sendEmail(mailVC: mail)
//            let output = self.outputMethod.sendEmail(to: emailAddress, message: message)
//            guard outputMethod.sendEmail(to: emailAddress, message: message) else { return }
        }, onError: { (error) in
            guard Output().sendEmail(to: emailAddress, message: error.localizedDescription) else { return }
        }, onCompleted: {
            guard Output().sendEmail(to: emailAddress, message: "You will no longer receive updates about \(subject.url)") else { return }
        })
    }
    
    func createSMSSubscriber(forSubject subject: WebPageSubject, sendTo number: String, carrier: Carrier) {
        let _ = subject.subject.subscribe(onNext: { (message) in
            guard Output().sendText(to: number, carrier: carrier, message: message) else { return } // TODO: Message should not just be a date
        }, onError: { (error) in
            guard Output().sendText(to: number, carrier: carrier, message: error.localizedDescription) else { return }
        }, onCompleted: {
            guard Output().sendText(to: number, carrier: carrier, message: "You will no longer receive updates about \(subject.url)") else { return }
        })
    }
    
    func createConsoleSubscriber(forSubject subject: WebPageSubject){
        let _ = subject.subject.subscribe(onNext: { (message) in
            print(message)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("You will no longer receive updates about \(subject.url)")
        })
    }
}
