//
//  WebPageObserver.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class WebPageObserver: Hashable { // TODO: Rename ...subject
    
    let subject: PublishSubject<String>
    let url: String
    var dateModified: String
    
    init(subject: PublishSubject<String>, url: String, dateModified: String) {
        self.subject = subject
        self.url = url
        self.dateModified = dateModified
    }
    
    func checkForUpdates(){
        ConnectionHandler.instance.getDateModified(for: self) { (error, date) in
            if let error = error {
                self.subject.onError(error)
            } else if let date = date {
                self.subject.onNext(date)
            }
        }
    }
    
    // TODO: Remove hashable?
    static func == (lhs: WebPageObserver, rhs: WebPageObserver) -> Bool {
        return lhs.subject == rhs.subject && lhs.url == rhs.url && lhs.dateModified == rhs.dateModified
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subject)
        hasher.combine(url)
        hasher.combine(dateModified)
    }
}
