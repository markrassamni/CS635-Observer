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

class WebPageSubject: Hashable {
    
    let subject: PublishSubject<String>
    let url: String
    var dateModified: String
    
    init(subject: PublishSubject<String>, url: String, dateModified: String) {
        self.subject = subject
        self.url = url
        self.dateModified = dateModified
    }
    
    func createEmailSubscriber(emailAddress: String) {
        let _ = subject.subscribe(onNext: { (message) in
            //            guard MFMailComposeViewController.canSendMail() else { return }
            //            let mail = MFMailComposeViewController()
            //            mail.mailComposeDelegate = self
            //            mail.setToRecipients([address])
            //            mail.setMessageBody(message, isHTML: false)
            //            present(mail, animated: true)
        }, onError: { (error) in
            // TODO: email error
        }, onCompleted: {
            // email complete
        })
    }
    
    func createSMSSubscriber(number: String, carrier: Carrier) {
        let _ = subject.subscribe(onNext: { (event) in
            //        guard MFMailComposeViewController.canSendMail() else { return }
            //        let mail = MFMailComposeViewController()
            //        mail.mailComposeDelegate = self
            //        let address = "\(number)@\(carrier.address)"
            //        mail.setToRecipients([address])
            //        mail.setMessageBody(message, isHTML: false)
            //        present(mail, animated: true)
        }, onError: { (error) in
            // SMS an error
        }, onCompleted: {
            // sms complete
        })
    }
    
    func createConsoleSubscriber(){
        let _ = subject.subscribe(onNext: { (message) in
            print(message)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("\(self) has completed.")
        })
    }
    
    func checkForUpdates(){
        ConnectionHandler.instance.getDateModified(forSubject: self) { (error, date) in
            if let error = error {
                self.subject.onError(error)
            } else if let date = date {
                self.subject.onNext(date)
            }
        }
    }
    
    // TODO: Remove hashable?
    static func == (lhs: WebPageSubject, rhs: WebPageSubject) -> Bool {
        return lhs.subject == rhs.subject && lhs.url == rhs.url && lhs.dateModified == rhs.dateModified
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subject)
        hasher.combine(url)
        hasher.combine(dateModified)
    }
}

extension PublishSubject: Hashable {
    public static func == (lhs: PublishSubject<Element>, rhs: PublishSubject<Element>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}
