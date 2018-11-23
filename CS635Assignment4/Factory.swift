//
//  Factory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import Alamofire

class Factory {
    
    func getDateModified(of url: String, dateCompletion: @escaping (String?)->()){
        Alamofire.request(url).responseJSON { (response) in
            guard let date = response.response?.allHeaderFields["Date"] as? String else {
                dateCompletion(nil)
                return
            }
            dateCompletion(date) // Fri, 23 Nov 2018 17:54:15 GMT
        }
    }
}
