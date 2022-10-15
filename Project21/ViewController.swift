//
//  ViewController.swift
//  Project21
//
//  Created by Edwin Przeźwiecki Jr. on 12/10/2022.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleFirstLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh...")
            }
        }
    }
    // Challenge 2:
    @objc func scheduleFirstLocal() {
        scheduleLocal(time: 5)
    }
    // Challenge 2:
    // Switched the selector in "Schedule" button and added a parameter to the following function:
    @objc func scheduleLocal(time: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        /* var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 15
         
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true) */
        
        // Challenge 2:
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        // Challenge 2:
        let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Pull out the buried userInfo dictionary.
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // The user swiped to unlock.
                // Challenge 1:
                let ac = UIAlertController(title: "Swipe", message: "You just swiped your finger to open the app.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Default identifier")
                
            case "show":
                // The user tapped our "Tell me more..." button.
                // Challenge 1:
                let ac = UIAlertController(title: "Button", message: "You just discovered a hidden option button!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Show more information...")
                
                //Challenge 2:
            case "reminder":
                scheduleLocal(time: 86400)
                let ac = UIAlertController(title: "Reminder", message: "Okay then, we will remind you tomorrow!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                print("Reminder set.")
                
            default:
                break
            }
        }
        // We must call the completion handler when we're done.
        completionHandler()
    }
}

