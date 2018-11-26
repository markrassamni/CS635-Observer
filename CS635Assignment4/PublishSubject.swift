//
//  PublishSubject.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/24/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

extension PublishSubject: Hashable {
    
    func createEmailSubscriber(emailAddress: String) {
        let _ = subscribe(onNext: { (message) in
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
        let _ = subscribe(onNext: { (event) in
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
        let _ = subscribe(onNext: { (message) in
            print(message)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("\(self) has completed.")
        })
    }
    
    // TODO: Does it need to be hashable?
    public static func == (lhs: PublishSubject<Element>, rhs: PublishSubject<Element>) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}
