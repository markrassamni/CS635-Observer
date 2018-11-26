//
//  Factory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

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
    
    func createEmailSubscriber(forSubject subject: WebPageSubject, sendTo emailAddress: String){
        let _ = subject.subject.subscribe(onNext: { (message) in
            guard Output().sendEmail(to: emailAddress, message: message) else { return }
        }, onError: { (error) in
            guard Output().sendEmail(to: emailAddress, message: error.localizedDescription) else { return }
        }, onCompleted: {
            guard Output().sendEmail(to: emailAddress, message: "You will no longer receive updates about \(subject.url)") else { return }
        })
    }
    
    func createSMSSubscriber(forSubject subject: WebPageSubject, sendTo number: String, carrier: Carrier) {
        let _ = subject.subject.subscribe(onNext: { (message) in
            guard Output().sendText(to: number, carrier: carrier, message: message) else { return }
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
