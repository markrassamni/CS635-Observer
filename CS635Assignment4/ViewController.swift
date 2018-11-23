//
//  ViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/19/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let a = "https://dzone.com/articles/6-reasons-why-you-should-go-for-a-static-website"
        let b = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
        Factory().getDateModified(of: b) { (date) in
            guard let date = date else { return }
            print(date)
            ()
        }
    }


}

