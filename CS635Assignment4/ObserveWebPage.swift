//
//  ObserveWebPage.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/25/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
import RxSwift

struct ObserveWebPage {
    let subscriber: Disposable
    let url: String
}
