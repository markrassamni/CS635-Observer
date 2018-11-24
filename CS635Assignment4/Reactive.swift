//
//  Reactive.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/24/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

// TODO: Separate into subscriber and subject factory?
class ReactiveFactory {
    
    // TODO: Move this and the extension to a different class, not in the factory
    var subjectDatesModified = [PublishSubject<String>:String]()
    
    func createStringPublishSubject() -> PublishSubject<String> {
        return PublishSubject<String>()
    }
    
    func checkWebPageForUpdates(url: String, dateUpdated: @escaping (String?)->()){
        Alamofire.request(url).responseJSON { (response) in
            guard let date = response.response?.allHeaderFields["Date"] as? String else {
                dateUpdated(nil)
                return
            }
            dateUpdated(date)
        }
    }
}
