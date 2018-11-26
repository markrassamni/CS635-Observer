//
//  ConnectionHandler.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionHandler {
    
    static let instance = ConnectionHandler()
    private init(){}
    
    func getDateModified(forSubject subject: WebPageSubject, completion: @escaping (Error?, String?)->()){
        getDateModified(forURL: subject.url) { (error, date) in
            completion(error, date)
        }
    }
    
    func getDateModified(forURL url: String, completion: @escaping (Error?, String?)->()){
        Alamofire.request(url).responseString { (response) in
            switch response.result{
            case .failure(let error):
                completion(error, nil)
            case .success:
                guard let date = response.response?.allHeaderFields["Date"] as? String else {
                    completion(DateError.noDate, nil)
                    return
                }
                completion(nil, date)
            }
        }
    }
}

fileprivate struct DateError: LocalizedError {
    
    private var description: String
    static let noDate = DateError(description: NSLocalizedString("Could not retrieve date from header field.",comment: ""))
    
    var errorDescription: String? {
        return description
    }
}