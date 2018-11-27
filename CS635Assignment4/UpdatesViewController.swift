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
    
    func begin(file: String, existingSubjects: [WebPageSubject], timeInterval: TimeInterval, connection: ConnectionHandler) -> Bool {
        return FileParser().readFile(file: file, connectionHandler: connection, existingSubjects: existingSubjects, sender: self) { (subjects) in
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
    
    func presentMailViewController(mailVC: MFMailComposeViewController, presented: (()->())?){
        guard MFMailComposeViewController.canSendMail() else { return }
        mailVC.mailComposeDelegate = self
        self.present(mailVC, animated: true) {
            if presented != nil {
                presented!()
            }
        }
    }
}
