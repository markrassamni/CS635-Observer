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
        let mail = MFMailComposeViewController()
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        return mail
    }
    
    func createText(to number: String, carrier: Carrier, message: String) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        let address = "\(number)@\(carrier.address)"
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        return mail
    }
    
    func createConsoleOutput(message: String) -> String {
        return message
    }
}
