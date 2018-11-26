//
//  WebPageSubject.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class WebPageSubject {
    
    let subject: PublishSubject<String>
    let url: String
    var dateModified: String
    
    // TODO: Also pass in an output/mock subscriber factory
    init(subject: PublishSubject<String>, url: String, dateModified: String) {
        self.subject = subject
        self.url = url
        self.dateModified = dateModified
    }
    
    func createEmailSubscriber(emailAddress: String) {
        let _ = subject.subscribe(onNext: { (message) in
            guard Output().sendEmail(to: emailAddress, message: message) else { return }
        }, onError: { (error) in
            guard Output().sendEmail(to: emailAddress, message: error.localizedDescription) else { return }
        }, onCompleted: {
            guard Output().sendEmail(to: emailAddress, message: "You will no longer receive updates about \(self.url)") else { return }
        })
    }
    
    func createSMSSubscriber(number: String, carrier: Carrier) {
        let _ = subject.subscribe(onNext: { (message) in
            guard Output().sendText(to: number, carrier: carrier, message: message) else { return }
        }, onError: { (error) in
            guard Output().sendText(to: number, carrier: carrier, message: error.localizedDescription) else { return }
        }, onCompleted: {
            guard Output().sendText(to: number, carrier: carrier, message: "You will no longer receive updates about \(self.url)") else { return }
        })
    }
    
    func createConsoleSubscriber(){
        let _ = subject.subscribe(onNext: { (message) in
            print(message)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("You will no longer receive updates about \(self.url)")
        })
    }
    
    func checkForUpdates(connectionHandler: ConnectionProtocol){
        connectionHandler.getDateModified(forSubject: self) { (error, date) in
            if let error = error {
                self.subject.onError(error)
            } else if let date = date {
                self.dateModified = date
                self.subject.onNext(date)
            }
        }
    }
}
