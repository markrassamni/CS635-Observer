//
//  WebPage.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/22/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation

protocol WebPage {
    var url: String { get }
    var output: Output { get }
    var recipient: String? { get }
}
