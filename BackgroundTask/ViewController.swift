//
//  ViewController.swift
//  BackgroundTask
//
//  Created by cyan on 8/30/17.
//  Copyright © 2017 cyan. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    submit {
      
    }
  }

  @IBAction func schedule(_ sender: UIButton) {
    
    let submitAction = UNNotificationAction(identifier: "Submit", title: "Submit", options: [])
    let ignoreAction = UNNotificationAction(identifier: "Ignore", title: "Ignore", options: [.destructive])
    let category = UNNotificationCategory(identifier: "Category", actions: [submitAction, ignoreAction], intentIdentifiers: [], options: [])
    
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = "Submit build to App Store"
    content.sound = nil
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    content.categoryIdentifier = "Category"
    
    let identifier = "Notification"
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories([category])
    center.delegate = self
    center.add(request)
  }
  
  fileprivate func submit(completion: @escaping () -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: URL(string: "http://api.fixer.io/latest?base=USD&symbols=CNY")!) { data, _, _ in
      guard let data = data, let string = String(data: data, encoding: .utf8) else {
        return
      }
      print(string)
      DispatchQueue.main.async {
        completion()
      }
    }
    task.resume()
  }
}

extension ViewController: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    switch response.actionIdentifier {
    case "Submit":
      print("Submit")
      let task = BackgroundTask(withName: "BackgroundTask")
      task.startTask()
      submit {
        task.endTask()
      }
    case "Ignore":
      print("Ignore")
    default:
      print("Unknown action")
    }
    
    completionHandler()
  }
}
