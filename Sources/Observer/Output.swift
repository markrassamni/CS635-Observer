//
//  Output.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import SwiftSMTP

class Output {
    
    func sendEmail(to user: Mail.User, message: String) {
        let smtp = SMTP(
            hostname: "smtp.gmail.com",
            email: "user@gmail.com",
            password: "password"
        )
        let sender = Mail.User(name: "Mark Rassamni", email: "markrassamni@gmail.com")
        
        let mail = Mail(
            from: sender,
            to: [user],
            subject: "WebPage Changed",
            text: message
        )
        // TODO: Remove closure and do not show error
        smtp.send(mail) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
}
