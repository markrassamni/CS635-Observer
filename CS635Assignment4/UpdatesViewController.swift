//
//  UpdatesViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit
import MessageUI

class UpdatesViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var timer: Timer?
    var subjects: [WebPageSubject]?
    var connectionHandler: ConnectionHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // TODO: Implement this class
    // Factory : createEmail(to: emailAddress, message: "Web page \(subject.url) has been updated at \(subject.dateModified)")
    
    func beginCheckingForUpdates(onSubjects subjects: [WebPageSubject], every timeInterval: TimeInterval, onConnection connectionHandler: ConnectionHandler){
        timer?.invalidate()
        self.subjects = subjects
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(checkForUpdates), userInfo: nil, repeats: true)
        self.connectionHandler = connectionHandler
    }
    
    
    @objc func checkForUpdates(){
        guard let subjects = self.subjects, let connectionHandler = self.connectionHandler else { return }
        // TODO: Not first!, need to check all
        subjects.first!.checkForUpdates(connectionHandler: connectionHandler) { (didUpdate) in
            if didUpdate {
//                subjects.first!.subject.onNext(<#T##element: String##String#>)
                // on next already called in check for updates, here just need to present, need another value returned with didUpdate to handle what to do - return or present mail
                
            }
        }
    }
    
    func presentMailViewController(mailVC: MFMailComposeViewController){
        present(mailVC, animated: true, completion: nil)
    }
    
    func sendEmail(to address: String, message: String) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        let mail = MFMailComposeViewController()
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        return mail
    }
    
    func sendText(to number: String, carrier: Carrier, message: String) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        let mail = MFMailComposeViewController()
        let address = "\(number)@\(carrier.address)"
        mail.setToRecipients([address])
        mail.setMessageBody(message, isHTML: false)
        return mail
    }
    
    func sendToConsole(message: String) -> String {
        return message
    }
    

}
