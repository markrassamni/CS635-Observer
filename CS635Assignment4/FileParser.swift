//
//  FileParser.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/20/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

// TODO: Each line of the file should check if a subject for that URL exists, if it exists, add subscriber to it, if not create new subject and subscribe to it
// Pass in a context to read file (var subjectDatesModified = [PublishSubject<String>:String]())
class FileParser {
    
    private let emailKey = "mail"
    private let smsKey = "sms"
    private let consoleKey = "console"
    
    func readFile(file: String) -> [WebPageObserver]?{
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return nil }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            let factory = ReactiveFactory()
            let subject = factory.createStringPublishSubject()
            lines = data.components(separatedBy: .newlines)
            var observers = [WebPageObserver]()
            for line in lines {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return nil }
                    let _ = subject.createEmailSubscriber(emailAddress: lineComponents[2])
                    let url = lineComponents[0]
                    observers.append(WebPageObserver(subject: subject, url: url))
                case smsKey:
                    guard lineComponents.count == 3, let carrier = Carrier(name: lineComponents[3]) else { return nil }
                    let _ = subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                    let url = lineComponents[0]
                    observers.append(WebPageObserver(subject: subject, url: url))
                case consoleKey:
                    guard lineComponents.count == 2 else { return nil }
                    let _ = subject.createConsoleSubscriber()
                    let url = lineComponents[0]
                    observers.append(WebPageObserver(subject: subject, url: url))
                default:
                    return nil
                }
            }
            return observers
        } catch { return nil }
    }
}
