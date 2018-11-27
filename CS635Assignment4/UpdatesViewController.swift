//
//  UpdatesViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit
import MessageUI

class UpdatesViewController: UIViewController, MFMailComposeViewControllerDelegate, SenderProtocol {

    var timer: Timer?
    var subjects: [WebPageSubject]?
    var connectionHandler: ConnectionHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TODO: Parse file and set vars
    }
    // TODO: Implement this class
    
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
    
    func presentMailViewController(mailVC: MFMailComposeViewController, presented: (()->())?){
        guard MFMailComposeViewController.canSendMail() else { return }
        mailVC.mailComposeDelegate = self
        self.present(mailVC, animated: true) {
            if presented != nil {
                presented!()
            }
        }
    }
    
    func sendMail(mailVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        presentMailViewController(mailVC: mailVC, presented: nil)
        return nil
    }
    
    func sendText(textVC: MFMailComposeViewController) -> MFMailComposeViewController? {
        presentMailViewController(mailVC: textVC, presented: nil)
        return nil
    }
    
    func sendConsole(output: String) -> String? {
        print(output)
        return nil
    }
}
