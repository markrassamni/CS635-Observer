//
//  OutputFactory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

class OutputFactory {
    
    private init(){}
    static let instance = OutputFactory()
    
    func createEmail(to address: String, message: String) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.setSubject("Webpage updated")
        mailVC.setToRecipients([address])
        mailVC.setMessageBody(message, isHTML: false)
        return mailVC
    }
    
    func createText(to number: String, carrier: Carrier, message: String) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
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
