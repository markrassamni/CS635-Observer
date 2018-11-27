//
//  OutputFactory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class OutputFactory {
    
    private init(){}
    static let instance = OutputFactory()
    
    func createEmail(to address: String, message: String) -> MailViewController {
        let mailVC = MailViewController()
        mailVC.setSubject("Webpage updated")
        mailVC.setToRecipients([address])
        mailVC.setMessageBody(message, isHTML: false)
        return mailVC
    }
    
    func createText(to number: String, carrier: Carrier, message: String) -> MailViewController {
        let mailVC = MailViewController()
        let address = "\(number)@\(carrier.address)"
        mailVC.setSubject("Webpage updated")
        mailVC.setToRecipients([address])
        mailVC.setMessageBody(message, isHTML: false)
        return mailVC
    }
    
    func createConsoleOutput(message: String) -> String {
        return message
    }
}
