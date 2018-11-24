//
//  Factory.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/23/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import Foundation
//import Alamofire
import RxSwift
import RxAlamofire
//import SwiftyJSON

class Factory {
    
    // TODO: Factory should be used exclusively for mock objects
    
    func createConsoleObserver<E>(_ element: E) -> Observable<E>{
        
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    func createStringPublishSubject() -> PublishSubject<String> {
        return PublishSubject<String>()
    }
    
    func checkIfDateChanged(newDate: String) -> Bool{
        let globalPastDate = "Date"
        return newDate != globalPastDate
    }
    
    func test(){
        
    }
    
    
    
    // Keep this let wherever subscribers are moved
    let message = ""
    func createEmailSubscriber(subject: PublishSubject<String>, emailAddress: String){
        subject.subscribe { (event) in
//            guard MFMailComposeViewController.canSendMail() else { return }
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients([address])
//            mail.setMessageBody(message, isHTML: false)
//            present(mail, animated: true)
        }
    }
    
    func createSMSSubscriber(subject: PublishSubject<String>, number: String, carrier: Carrier){
        subject.subscribe { (event) in
//        guard MFMailComposeViewController.canSendMail() else { return }
//        let mail = MFMailComposeViewController()
//        mail.mailComposeDelegate = self
//        let address = "\(number)@\(carrier.address)"
//        mail.setToRecipients([address])
//        mail.setMessageBody(message, isHTML: false)
//        present(mail, animated: true)
        }
    }
    
    func createConsoleSubscriber(subject: PublishSubject<String>) -> Disposable{
        return subject.subscribe { (event) in
            guard let element = event.element else { return }
            print(element)
        }
    }
    
    func testObserve(url: String){
    
        let subject = createStringPublishSubject()
        subject.subscribe(onNext: {print("Subject = \($0)")})
        subject.onNext("newDate")
        
        
        
        let a = request(.get, url).responseString().observeOn(MainScheduler.instance)
//        MainScheduler.instance.schedulePeriodic(.normal, startAfter: RxTimeInterval(exactly: 0)!, period: RxTimeInterval(exactly: 5)!, action: a.do(onNext: { (response)  in
//            print(response)
//            print(stringVal)
//            ()
//        }))
        
        a.subscribe {
            if let b = $0.element {
                let c = b.0.allHeaderFields
                let date = c["Date"] as? String
                print(date) // Working to get date, optional, needs unwrapped
            }
            //            print($0)
            ()
        }
        a.do(onNext: { (b) in
            print("got it")
            ()
        })
        
        ()
        /*
        let a = createConsoleObserver(RxAlamofire.request(.get, url).responseJSON())
//        let a = RxAlamofire.request(.get, url).responseJSON()
        a.subscribe(onNext: { (date) in
            if date is JSON {
                print("1")
            } else {
                print("2")
            }
            print(date)
            ()
        })
 */
    }
    
    func observeDateModified(for url: String){
//        let sched = SerialDispatchQueueScheduler(qos: .default)
//        let data = Observable<String>.interval(5, scheduler: sched)
    }
    
    func getDateModified(of url: String, dateCompletion: @escaping (String?)->()){
        if let a = URL(string: url) {
            let request = URLRequest(url: a)
//            let respJSON = URLSession.shared.rx.base.
            
        }
        
        RxAlamofire.request(.get, url).responseJSON().observeOn(MainScheduler.instance)
//        RxAlamofire.requestJSON(.get, url).subscribe(onNext: <#T##(((HTTPURLResponse, Any)) -> Void)?##(((HTTPURLResponse, Any)) -> Void)?##((HTTPURLResponse, Any)) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        /*
        Alamofire.request(url).responseJSON { (response) in
            guard let date = response.response?.allHeaderFields["Date"] as? String else {
                dateCompletion(nil)
                return
            }
            dateCompletion(date) // Fri, 23 Nov 2018 17:54:15 GMT
        }
 */
    }
}
