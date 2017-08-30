//
//  BackgroundTask.swift
//  BackgroundTask
//
//  Created by cyan on 8/30/17.
//  Copyright © 2017 cyan. All rights reserved.
//

import UIKit

class BackgroundTask {
  
  private let taskName: String
  private var taskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
  
  init(withName name: String) {
    self.taskName = name
  }
  
  public func startTask() {
    self.startTask {
      print("\(self.taskIdentifier) background task time expired before ending")
    }
  }
  
  public func startTask(withExpirationHandler expirationHandler: @escaping (() -> Void)) {
    guard taskIdentifier == UIBackgroundTaskInvalid else {
      print("Task \(taskName) already running")
      return
    }
    
    taskIdentifier = UIBackgroundTaskIdentifier(doBackgroundTask(taskName) {
      expirationHandler()
      self.endTask()
    })
  }
  
  public func endTask() {
    guard taskIdentifier != UIBackgroundTaskInvalid else {
      print("Task \(taskName) is not running, can't end")
      return
    }
    
    let task = Int(taskIdentifier)
    taskIdentifier = UIBackgroundTaskInvalid
    
    endBackgroundTask(task)
  }
  
  private func doBackgroundTask(_ taskName: String, expirationHandler: @escaping () -> Void) -> Int {
    let taskId = UIApplication.shared.beginBackgroundTask(withName: taskName, expirationHandler: expirationHandler)
    return taskId
  }
  
  private func endBackgroundTask(_ taskId: Int) {
    UIApplication.shared.endBackgroundTask(taskId as UIBackgroundTaskIdentifier)
  }
}
