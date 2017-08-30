//
//  AppDelegate.swift
//  BackgroundTask
//
//  Created by cyan on 8/30/17.
//  Copyright © 2017 cyan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
      (granted, error) in
      if !granted {
        print("Something went wrong")
      }
    }
    
    return true
  }
}
