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
    
    /// Boolean returned represents if successfully read all lines. Completion returns the array of subjects created
    func readFile(file: String, connectionHandler: ConnectionProtocol, existingSubjects: [WebPageSubject] = [WebPageSubject](), completion: @escaping ([WebPageSubject]) -> ()) -> Bool {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return false }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            var newSubjects = existingSubjects
            var newSubjectCount = 0
            var gotDateCount = 0
            lines = data.components(separatedBy: .newlines)
            for (index, line) in lines.enumerated() {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                guard lineComponents.count > 1 else {
                    if isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                        completion(newSubjects)
                    }
                    return index == lines.count - 1
                }
                let url = lineComponents[0]
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return false }
                    if let subject = newSubjects.subject(forURL: url) {
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                        gotDateCount += 1
                        if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                            completion(newSubjects)
                        }
                    } else {
                        newSubjectCount += 1
                        connectionHandler.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            gotDateCount += 1
                            let subject = Factory.instance.createWebPageSubject(url: url, dateModified: date)
                            subject.createEmailSubscriber(emailAddress: lineComponents[2])
                            newSubjects.append(subject)
                            if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                                completion(newSubjects)
                            }
                        }
                    }
                case smsKey:
                    guard lineComponents.count == 4, let carrier = Carrier(name: lineComponents[3]) else { return false }
                    if let subject = newSubjects.subject(forURL: url){
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                        gotDateCount += 1
                        if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                            completion(newSubjects)
                        }
                    } else {
                        newSubjectCount += 1
                        connectionHandler.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            gotDateCount += 1
                            let subject = Factory.instance.createWebPageSubject(url: url, dateModified: date)
                            subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                            newSubjects.append(subject)
                            if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                                completion(newSubjects)
                            }
                        }
                    }
                case consoleKey:
                    guard lineComponents.count == 2 else { return false }
                    if let subject = newSubjects.subject(forURL: url) {
                        subject.createConsoleSubscriber()
                        gotDateCount += 1
                        if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                            completion(newSubjects)
                        }
                    } else {
                        newSubjectCount += 1
                        connectionHandler.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            gotDateCount += 1
                            let subject = Factory.instance.createWebPageSubject(url: url, dateModified: date)
                            subject.createConsoleSubscriber()
                            newSubjects.append(subject)
                            if self.isFinishedGettingDates(dateCount: gotDateCount, lineCount: lines.count){
                                completion(newSubjects)
                            }
                        }
                    }
                default:
                    return false
                }
            }
            return true
        } catch { return false }
    }
    
    private func isFinishedGettingDates(dateCount: Int, lineCount: Int) -> Bool {
        return dateCount == lineCount - 1 // Have to remove an extra count because last line is empty in XCode txt file
    }
}

fileprivate extension Array where Element: WebPageSubject {
    mutating func subject(forURL url: String) -> WebPageSubject?{
        return filter{$0.url == url}.first
    }
}
