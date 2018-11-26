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
    
    func readFile(file: String, context: Context) -> [PublishSubject<String>]? {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return nil }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            var subjects = [PublishSubject<String>]()
            let factory = ReactiveFactory()
            lines = data.components(separatedBy: .newlines)
            for line in lines {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return nil }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                        subjects.append(subject)
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                        subjects.append(subject)
                    }
                case smsKey:
                    guard lineComponents.count == 3, let carrier = Carrier(name: lineComponents[3]) else { return nil }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                        subjects.append(subject)
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                        subjects.append(subject)
                    }

                case consoleKey:
                    guard lineComponents.count == 2 else { return nil }
                    let url = lineComponents[0]
                    if let subject = context.getSubject(forURL: url) {
                        subject.createConsoleSubscriber()
                        subjects.append(subject)
                    } else {
                        let subject = factory.createStringPublishSubject()
                        context.setSubject(forURL: url, to: subject)
                        subject.createConsoleSubscriber()
                        subjects.append(subject)
                    }
                default:
                    return nil
                }
            }
            return subjects
        } catch { return nil }
    }
}
