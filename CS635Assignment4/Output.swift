//
//  Output.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

class Output: OutputProtocol { // Rename to OutputFactory or add to other factory
    
    let updatesVC = UpdatesViewController()
    
    // TODO: This will call UpdateVC.present, Mock will just return
    func sendEmail(to address: String, message: String) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        let mail = MFMailComposeViewController()
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        updatesVC.presentMailViewController(mailVC: mail)
        return nil
    }
    
    func sendText(to number: String, carrier: Carrier, message: String) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        let mail = MFMailComposeViewController()
        let address = "\(number)@\(carrier.address)"
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        updatesVC.presentMailViewController(mailVC: mail)
        return nil
    }
    
    func sendToConsole(message: String) -> String? {
        print(message)
        return nil
    }
}
