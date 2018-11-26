//
//  MockConnectionHandler.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

class MockConnectionHandler: ConnectionProtocol {
    
    private var mockDates: [String]
    private var currentDateIndex: Int
    
    init(mockDates: [String]) {
        self.mockDates = mockDates
        currentDateIndex = 0
    }
    
    func getDateModified(forSubject subject: WebPageSubject, completion: @escaping (Error?, String?) -> ()) {
        getDateModified(forURL: subject.url) { (error, date) in
            completion(error, date)
        }
    }
    
    func getDateModified(forURL url: String, completion: @escaping (Error?, String?) -> ()) {
        guard currentDateIndex < mockDates.count else {
            completion(DateError.noMockDates, nil)
            return
        }
        completion(nil, mockDates[currentDateIndex])
        currentDateIndex += 1
    }
}
