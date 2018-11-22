//
//  SMS.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class SMS: WebPage {
    
    let url: String
    let output: Output
    let recipient: String?
    
    init(url: String, output: Output, recipient: String) {
        self.url = url
        self.output = output
        self.recipient = recipient
    }
}
