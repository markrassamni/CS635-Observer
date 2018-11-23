//
//  WebPage.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class WebPage {
    let url: String
    let output: OutputType
    let recipient: String?
    
    init(url: String, output: OutputType, recipient: String?) {
        self.url = url
        self.output = output
        self.recipient = recipient
    }
}
