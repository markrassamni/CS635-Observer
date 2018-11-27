//
//  MockSender.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

class MockSender: SenderProtocol {
    func sendMail(mailVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        return mailVC
    }
    
    func sendText(textVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        return textVC
    }
    
    func sendConsole(output: String) -> String? {
        return output
    }
}