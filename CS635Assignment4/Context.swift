//
//  Context.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class Context {
    // TODO: Change values to a class that will also store the date modified
    private var subjectURLs = [String:PublishSubject<String>]()
    
    func getSubject(forURL url: String) -> PublishSubject<String>? {
        return subjectURLs[url]
    }
    
    func setSubject(forURL url: String, to subject: PublishSubject<String>){
        subjectURLs[url] = subject
    }
}
