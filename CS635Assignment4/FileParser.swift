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
    
    func readFile(file: String) {
        guard let filePath = Bundle.main.path(forResource: file, ofType: nil) else { return }
        let lines: [String]
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8).lowercased()
            lines = data.components(separatedBy: .newlines)
        } catch { return }
        let _ = convertToOutputMethod(lines: lines)
        // TODO: return an array of objects, change func name to BuildObjects..
    }
    
    private func convertToOutputMethod(lines: [String]) -> [WebPage]{
        var webPages = [WebPage]()
        for line in lines {
            let lineComponents = line.components(separatedBy: " ").filter{ $0 != "" }
            switch lineComponents[1]{
            case emailKey:
                guard lineComponents.count == 3 else { continue }
                webPages.append(WebPage(url: lineComponents[0], output: OutputType.mail, recipient: lineComponents[2]))
            case smsKey:
                guard lineComponents.count == 3 else { continue }
                webPages.append(WebPage(url: lineComponents[0], output: OutputType.sms, recipient: lineComponents[2]))
            case consoleKey:
                guard lineComponents.count == 2 else { continue }
                webPages.append(WebPage(url: lineComponents[0], output: OutputType.console, recipient: nil))
            default:
                continue
            }
        }
        return webPages
    }
}
