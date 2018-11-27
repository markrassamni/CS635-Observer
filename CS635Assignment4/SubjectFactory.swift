//
//  SubjectFactory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

class SubjectFactory {

    private init(){}
    static let instance = SubjectFactory()
    
    func createWebPageSubject(url: String, dateModified: String) -> WebPageSubject{
        return WebPageSubject(subject: createPublishSubject(), url: url, dateModified: dateModified)
    }
    
    func createPublishSubject() -> PublishSubject<String>{
        return PublishSubject<String>()
    }
}
