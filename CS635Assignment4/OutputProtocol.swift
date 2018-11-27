//
//  OutputProtocol.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import MessageUI

protocol OutputProtocol {
    func sendEmail(mailVC: MFMailComposeViewController) -> MFMailComposeViewController?
    
    func sendText(mailVC: MFMailComposeViewController) -> MFMailComposeViewController?
    
    func sendToConsole(message: String) -> String?
}
