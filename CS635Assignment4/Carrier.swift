//
//  Carrier.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

struct Carrier {
    let name: String
    var address: String
    
    init?(name: String) {
        self.name = name
        switch name.lowercased() {
        case "alltell":
            self.address = "mms.alltelwireless.com"
        case "att":
            self.address = "mms.att.net"
        case "boost":
            self.address = "myboostmobile.com"
        case "cricket":
            self.address = "mms.cricketwireless.net"
        case "projectfi":
            self.address = "msg.fi.google.com"
        case "sprint":
            self.address = "pm.sprint.com"
        case "tmobile":
            self.address = "tmomail.net"
        case "uscellular":
            self.address = "mms.uscc.net"
        case "verizon":
            self.address = "vzwpix.com"
        case "virgin":
            self.address = "vmpix.com"
        default:
            return nil
        }
    }
}
