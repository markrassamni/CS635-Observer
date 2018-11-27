//
//  OutputViewController.swift
//  CS635Assignment4
//
//  Created by Mark Rassamni on 11/26/18.
//  Copyright © 2018 Mark Rassamni. All rights reserved.
//

import UIKit
import MessageUI

class OutputViewController: UIViewController, MFMailComposeViewControllerDelegate, OutputProtocol {

    var timer: Timer?
    var subjects: [WebPageSubject]?
    var connectionHandler: ConnectionHandler?
    
    func begin(file: String, existingSubjects: [WebPageSubject], timeInterval: TimeInterval, connection: ConnectionHandler) -> Bool {
        return FileParser().readFile(file: file, connectionHandler: connection, existingSubjects: existingSubjects, output: self) { (subjects) in
            self.timer?.invalidate()
            self.subjects = subjects
            self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.checkForUpdates), userInfo: nil, repeats: true)
            self.connectionHandler = connection
        }
    }
 
    @objc func checkForUpdates(){
        guard let subjects = self.subjects, let connectionHandler = self.connectionHandler else { return }
        for subject in subjects {
            subject.checkForUpdates(connectionHandler: connectionHandler, updated: nil)
        }
    }
    
    func sendMail(mailVC: MailViewController) {
        presentMailViewController(mailVC: mailVC, presented: nil)
    }
    
    func sendText(textVC: MailViewController) {
        presentMailViewController(mailVC: textVC, presented: nil)
    }
    
    func sendConsole(output: String) {
        print(output)
    }
    
    func presentMailViewController(mailVC: MailViewController, presented: (()->())?){
        guard MailViewController.canSendMail() else { return }
        mailVC.mailComposeDelegate = self
        self.present(mailVC, animated: true) {
            if presented != nil {
                presented!()
            }
        }
    }
}
