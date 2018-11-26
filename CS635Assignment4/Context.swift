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
    
    private var subjectURLs = [String:PublishSubject<String>]()
    private var modifiedDateSubjects = [PublishSubject<String>:String]()
    
    func getSubject(forURL url: String) -> PublishSubject<String>? {
        return subjectURLs[url]
    }
    
    func setSubject(forURL url: String, to subject: PublishSubject<String>){
        subjectURLs[url] = subject
    }
    
    func getDate(forSubject subject: PublishSubject<String>) -> String?{
        return modifiedDateSubjects[subject]
    }
    
    func setDate(forSubject subject: PublishSubject<String>, to date: String){
        modifiedDateSubjects[subject] = date
    }
}
