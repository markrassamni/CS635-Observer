//
//  ViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/19/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let testURL = "https://dzone.com/articles/6-reasons-why-you-should-go-for-a-static-website"
//    enum DateError: LocalizedError{
//        case noDate(String)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let error = "The operation couldn’t be completed."
//        let error2 = "The operation couldn’t be completed.".localizedDescription
//        let a = DateError.noDate("Could not retrieve date from header field.")
//        let b = DateError.noDate("Could not retrieve date from header field.").localizedDescription
//        print(error)
//        print(error2)
//        let a = DateError(description: "Error")
//        let b = a .localizedDescription
//
//        print(a)
//        print(b)

        
//        let a = DateError(description: "A")
//        let b = DateError.noDate
//        let c = DateError.noDate.localizedDescription
        
//        print(b)
//        
//        print(c)
        
        
        testHeaders()
    }
    
    func test1(){
        let _ = "https://dzone.com/articles/6-reasons-why-you-should-go-for-a-static-website"
        let b = "http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html"
        Factory().getDateModified(of: b) { (date) in
            guard let date = date else { return }
            print(date)
            ()
        }
    }
    
    func test2(){
        Factory().testObserve(url: testURL)
    }
    
    func testHeaders(){
        Alamofire.request("http://www.eli.sdsu.edu/courses/fall18/cs635/notes/index.html").responseString { (response) in
            switch response.result{
            case .failure(let error):
                //                self.subject.onError(error)
                print(error.localizedDescription)
            case .success:
                let data = response.response?.allHeaderFields
                print(data ?? "No data")
                guard let date = response.response?.allHeaderFields["Date"] as? String else { return }
                print(date)
                print("Hi")
                ()
                //                self.subject.onNext(date)
            }
        }
    }


}

//fileprivate struct DateError: LocalizedError {
//    private var description: String
//
//    var errorDescription: String? {
//        return description
//    }
//}
