//
//  Reactive.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/24/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

// TODO: Separate into subscriber and subject factory?
class ReactiveFactory {
    
    // TODO: Move this and the extension to a different class, not in the factory
    var subjectDatesModified = [PublishSubject<String>:String]()
    
    func createStringPublishSubject() -> PublishSubject<String> {
        return PublishSubject<String>()
    }
    
    func createEmailSubscriber(subject: PublishSubject<String>, emailAddress: String) -> Disposable{
        return subject.subscribe(onNext: { (message) in
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
    
    func createSMSSubscriber(subject: PublishSubject<String>, number: String, carrier: Carrier) -> Disposable {
        return subject.subscribe(onNext: { (event) in
            //        guard MFMailComposeViewController.canSendMail() else { return }
            //        let mail = MFMailComposeViewController()
            //        mail.mailComposeDelegate = self
            //        let address = "\(number)@\(carrier.address)"
            //        mail.setToRecipients([address])
            //        mail.setMessageBody(message, isHTML: false)
            //        present(mail, animated: true)
        }, onError: { (error) in
            // TODO: SMS an error
        }, onCompleted: {
            // sms complete
        })
    }
    
    func createConsoleSubscriber(subject: PublishSubject<String>) -> Disposable{
        return subject.subscribe(onNext: { (message) in
            print(message)
        }, onError: { (error) in
            print(error.localizedDescription)
        }, onCompleted: {
            print("\(subject) has completed.")
        })
    }
    
    func checkWebPageForUpdates(url: String, dateUpdated: @escaping (String?)->()){
        Alamofire.request(url).responseJSON { (response) in
            guard let date = response.response?.allHeaderFields["Date"] as? String else {
                dateUpdated(nil)
                return
            }
            dateUpdated(date)
        }
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
