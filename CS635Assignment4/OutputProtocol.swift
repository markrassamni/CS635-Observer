//
//  OutputProtocol.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

protocol OutputProtocol {
    func sendMail(mailVC: MailViewController)
    func sendText(textVC: MailViewController)
    func sendConsole(output: String)
}
