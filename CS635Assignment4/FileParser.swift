//
//  FileParser.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/20/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class FileParser {
    
    private let emailKey = "mail"
    private let smsKey = "sms"
    private let consoleKey = "console"
    
    /// Boolean returned represents if successfully read all lines. Completion returns the array of subjects created
    func readFile(file: String, connectionHandler: ConnectionProtocol, existingSubjects: [WebPageSubject] = [WebPageSubject](), sender: SenderProtocol, completion: @escaping ([WebPageSubject]) -> ()) -> Bool {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return false }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            var newSubjects = existingSubjects
            var linesHandled = 0
            lines = data.components(separatedBy: .newlines)
            for (index, line) in lines.enumerated() {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                guard lineComponents.count > 1 else {
                    if isFinishedGettingDates(linesHandled: linesHandled, lineCount: lines.count){
                        completion(newSubjects)
                    }
                    return index == lines.count - 1
                }
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return false }
                    handleEmailKey(lineComponents: lineComponents, subjects: newSubjects, connectionHandler: connectionHandler, sender: sender) { (newSubject) in
                        linesHandled += 1
                        if let subject = newSubject {
                            newSubjects.append(subject)
                        }
                        if self.isFinishedGettingDates(linesHandled: linesHandled, lineCount: lines.count) {
                            completion(newSubjects)
                        }
                    }
                case smsKey:
                    guard lineComponents.count == 4, let carrier = Carrier(name: lineComponents[3]) else { return false }
                    handleSMSKey(lineComponents: lineComponents, subjects: newSubjects, carrier: carrier, connectionHandler: connectionHandler, sender: sender) { (newSubject) in
                        linesHandled += 1
                        if let subject = newSubject {
                            newSubjects.append(subject)
                        }
                        if self.isFinishedGettingDates(linesHandled: linesHandled, lineCount: lines.count) {
                            completion(newSubjects)
                        }
                    }
                case consoleKey:
                    guard lineComponents.count == 2 else { return false }
                    handleConsoleKey(lineComponents: lineComponents, subjects: newSubjects, connectionHandler: connectionHandler, sender: sender) { (newSubject) in
                        linesHandled += 1
                        if let subject = newSubject {
                            newSubjects.append(subject)
                        }
                        if self.isFinishedGettingDates(linesHandled: linesHandled, lineCount: lines.count) {
                            completion(newSubjects)
                        }
                    }
                default:
                    return false
                }
            }
            return true
        } catch { return false }
    }
    
    private func handleEmailKey(lineComponents: [String], subjects: [WebPageSubject], connectionHandler: ConnectionProtocol, sender: SenderProtocol, newSubject: @escaping (WebPageSubject?)->()) {
        let url = lineComponents[0]
        let email = lineComponents[2]
        if let subject = subjects.subject(forURL: url) {
            subject.createEmailSubscriber(sendTo: email, sender: sender)
            newSubject(nil)
        } else {
            connectionHandler.getDateModified(forURL: url) { (error, date) in
                guard error == nil, let date = date else { return }
                let subject = SubjectFactory.instance.createWebPageSubject(url: url, dateModified: date)
                subject.createEmailSubscriber(sendTo: email, sender: sender)
                newSubject(subject)
            }
        }
    }
    
    private func handleSMSKey(lineComponents: [String], subjects: [WebPageSubject], carrier: Carrier, connectionHandler: ConnectionProtocol, sender: SenderProtocol, newSubject: @escaping (WebPageSubject?)->()){
        let url = lineComponents[0]
        let number = lineComponents[2]
        if let subject = subjects.subject(forURL: url){
            subject.createSMSSubscriber(sendTo: number, carrier: carrier, sender: sender)
            newSubject(nil)
        } else {
            connectionHandler.getDateModified(forURL: url) { (error, date) in
                guard error == nil, let date = date else { return }
                let subject = SubjectFactory.instance.createWebPageSubject(url: url, dateModified: date)
                subject.createSMSSubscriber(sendTo: number, carrier: carrier, sender: sender)
                newSubject(subject)
            }
        }
    }
    
    private func handleConsoleKey(lineComponents: [String], subjects: [WebPageSubject], connectionHandler: ConnectionProtocol, sender: SenderProtocol, newSubject: @escaping (WebPageSubject?)->()){
        let url = lineComponents[0]
        if let subject = subjects.subject(forURL: url) {
            subject.createConsoleSubscriber(sender: sender)
            newSubject(nil)
        } else {
            connectionHandler.getDateModified(forURL: url) { (error, date) in
                guard error == nil, let date = date else { return }
                let subject = SubjectFactory.instance.createWebPageSubject(url: url, dateModified: date)
                subject.createConsoleSubscriber(sender: sender)
                newSubject(subject)
            }
        }
    }
    
    private func isFinishedGettingDates(linesHandled: Int, lineCount: Int) -> Bool {
        return linesHandled == lineCount - 1 // Have to remove an extra count because last line is empty in XCode txt file
    }
}

fileprivate extension Array where Element: WebPageSubject {
    func subject(forURL url: String) -> WebPageSubject? {
        return filter{$0.url == url}.first
    }
}
