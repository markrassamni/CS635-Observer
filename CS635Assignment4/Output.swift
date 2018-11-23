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
    
    func sendEmail(to address: String, message: String){
        guard MFMailComposeViewController.canSendMail() else { return }
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            mail.setMessageBody(message, isHTML: false)
            present(mail, animated: true)
    }
}