//
//  DateError.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

struct DateError: LocalizedError {
    
    private var description: String
    static let noDate = DateError(description: NSLocalizedString("Could not retrieve date from header field.",comment: ""))
    static let noMockDates = DateError(description: NSLocalizedString("All mocked dates have been returned.", comment: ""))
    
    var errorDescription: String? {
        return description
    }
}
