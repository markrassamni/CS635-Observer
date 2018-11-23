//
//  Output.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

//import Foundation
import Cocoa

class Output {
    
    func sendEmail(to address: String, message: String){
        let service = NSSharingService(named: .composeEmail)
        service?.recipients = [address]
        service?.subject = "Website changed"
        service?.perform(withItems: [message])
        
        
    }
}
