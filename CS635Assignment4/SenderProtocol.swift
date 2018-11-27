//
//  SenderProtocol.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

protocol SenderProtocol {
    func sendMail(mailVC: MFMailComposeViewController) -> MFMailComposeViewController?
    func sendText(textVC: MFMailComposeViewController) -> MFMailComposeViewController?
    func sendConsole(output: String) -> String?
}
