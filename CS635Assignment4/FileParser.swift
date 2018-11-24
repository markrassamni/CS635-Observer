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
    
    // TODO: Return tuple [Observe(subscriber: Disposable, url: String)]. Or make it a struct?
    func readFile(file: String) -> [Disposable]?{
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return nil }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            let factory = ReactiveFactory()
            let subject = factory.createStringPublishSubject()
            lines = data.components(separatedBy: .newlines)
            var observers = [Disposable]()
            for line in lines {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return nil }
                    observers.append(subject.createEmailSubscriber(emailAddress: lineComponents[2]))
                case smsKey:
                    guard lineComponents.count == 3, let carrier = Carrier(name: lineComponents[3]) else { return nil }
                    observers.append(subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier))
                case consoleKey:
                    guard lineComponents.count == 2 else { return nil }
                    observers.append(subject.createConsoleSubscriber())
                default:
                    return nil
                }
            }
            return observers
        } catch { return nil }
    }
}
