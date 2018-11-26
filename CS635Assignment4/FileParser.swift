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
    
    /// Boolean returned represents if successfully read all lines
    func readFile(file: String, existingSubjects subjects: [WebPageSubject] = [WebPageSubject](), completion: @escaping ([WebPageSubject]) -> ()) -> Bool {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return false }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            var newSubjects = subjects
            lines = data.components(separatedBy: .newlines)
            for (index, line) in lines.enumerated() {
                let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
                guard lineComponents.count > 1 else { return false }
                let url = lineComponents[0]
                switch lineComponents[1]{
                case emailKey:
                    guard lineComponents.count == 3 else { return false }
                    if let subject = newSubjects.subject(forURL: url) {
                        subject.createEmailSubscriber(emailAddress: lineComponents[2])
                        if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
                            completion(newSubjects)
                        }
                    } else {
                        ConnectionHandler.instance.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            let subject = WebPageSubject(subject: PublishSubject<String>(), url: url, dateModified: date)
                            subject.createEmailSubscriber(emailAddress: lineComponents[2])
                            newSubjects.append(subject)
                            if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
                                completion(newSubjects)
                            }
                        }
                    }
                case smsKey:
                    guard lineComponents.count == 4, let carrier = Carrier(name: lineComponents[3]) else { return false }
                    if let subject = newSubjects.subject(forURL: url){
                        subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                        if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
                            completion(newSubjects)
                        }
                    } else {
                        ConnectionHandler.instance.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            let subject = WebPageSubject(subject: PublishSubject<String>(), url: url, dateModified: date)
                            subject.createSMSSubscriber(number: lineComponents[2], carrier: carrier)
                            newSubjects.append(subject)
                            if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
                                completion(newSubjects)
                            }
                        }
                    }
                case consoleKey:
                    guard lineComponents.count == 2 else { return false }
                    if let subject = newSubjects.subject(forURL: url) {
                        subject.createConsoleSubscriber()
                        if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
                            completion(newSubjects)
                        }
                    } else {
                        ConnectionHandler.instance.getDateModified(forURL: url) { (error, date) in
                            guard error == nil, let date = date else { return }
                            let subject = WebPageSubject(subject: PublishSubject<String>(), url: url, dateModified: date)
                            subject.createConsoleSubscriber()
                            newSubjects.append(subject)
                            if newSubjects.count == subjects.count + lines.count && index == lines.count-1 {
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
    
//    private func createEmailSubscriber(lineComponents: [String]){
//        guard lineComponents.count == 3 else { return }
//        let url = lineComponents[0]
//        if let subject = context.getSubject(forURL: url) {
//            WebPageSubject(subject: subject, url: url, dateModified: <#T##String#>)
//            subject.createEmailSubscriber(emailAddress: lineComponents[2])
//            subjects.append(subject)
//        } else {
//            let subject = factory.createStringPublishSubject()
//            context.setSubject(forURL: url, to: subject)
//            subject.createEmailSubscriber(emailAddress: lineComponents[2])
//            subjects.append(subject)
//        }
//    }
    
    private func createSMSSubscriber(line: [String]){
        
    }
    
    private func createConsoleSubscriber(line: [String]){
        
    }
}

// TODO: Change to class SubjectArray: Array ?
// And move to new file
extension Array where Element: WebPageSubject {
    
    mutating func subject(forURL url: String) -> WebPageSubject?{
        return filter{$0.url == url}.first
        
        // TODO: Do something like this to create or return the subject
//        if subject == nil {
//            subject = PublishSubject<String>()
//            append(subject)
//        }
//        return subject
    }
    
    func contains(subject: PublishSubject<String>) -> Bool {
        return self.contains { (element) -> Bool in
            element.subject == subject
        }
    }
    
    func contains(url: String) -> Bool {
        return self.contains { (element) -> Bool in
            element.url == url
        }
    }
}
