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
        Factory.instance.createEmailSubscriber(forSubject: self, sendTo: emailAddress)
    }
    
    func createSMSSubscriber(number: String, carrier: Carrier) {
        Factory.instance.createSMSSubscriber(forSubject: self, sendTo: number, carrier: carrier)
    }
    
    func createConsoleSubscriber(){
        Factory.instance.createConsoleSubscriber(forSubject: self)
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
