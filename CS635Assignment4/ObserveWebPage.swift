//
//  ObserveWebPage.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct ObserveWebPage {
    let subject: PublishSubject<String>
    let url: String
    
    func checkForUpdates(url: String, dateUpdated: @escaping (String?)->()){
        Alamofire.request(url).responseJSON { (response) in
            switch response.result{
            case .failure(let error):
                self.subject.onError(error)
            case .success:
                guard let date = response.response?.allHeaderFields["Date"] as? String else { return }
                // TODO: Compare to previous date
                self.subject.onNext(date)
            }
        }
    }
}
