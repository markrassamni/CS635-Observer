//
//  Output.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

class Output: UIViewController, MFMailComposeViewControllerDelegate {
    
    func sendEmail(to address: String, message: String) -> Bool {
        guard MFMailComposeViewController.canSendMail() else { return false }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        present(mail, animated: true)
        return true
    }
    
    func sendText(to number: String, carrier: Carrier, message: String) -> Bool {
        guard MFMailComposeViewController.canSendMail() else { return false }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        let address = "\(number)@\(carrier.address)"
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        present(mail, animated: true)
        return true
    }
    
    func sendToConsole(message: String) -> Bool {
        print(message)
        return true
    }
}
