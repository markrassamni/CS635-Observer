//
//  FileParser.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/20/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class FileParser {
    
    private let emailKey = "mail"
    private let smsKey = "sms"
    private let consoleKey = "console"
    
    /// Returns boolean denoting if file was read successfully
    func readFile(file: String, context: Context) -> Bool {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return false }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            let factory = ReactiveFactory()
            lines = data.components(separatedBy: .newlines)
            for line in lines {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return false }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                    }
                case smsKey:
                    guard lineComponents.count == 3, let carrier = Carrier(name: lineComponents[3]) else { return false }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                    }

                case consoleKey:
                    guard lineComponents.count == 2 else { return false }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createConsoleSubscriber()
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createConsoleSubscriber()
                    }
                default:
                    return false
                }
            }
            return true
        } catch { return false }
    }
}
