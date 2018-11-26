//
//  ConnectionProtocol.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

protocol ConnectionProtocol: class {
    func getDateModified(forURL url: String, completion: @escaping (Error?, String?) -> ())
    func getDateModified(forSubject subject: WebPageSubject, completion: @escaping (Error?, String?) -> ())
}
