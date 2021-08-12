//
//  NotificationController.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/06.
//

import WatchKit
import SwiftUI
import UserNotifications

//https://developer.apple.com/tutorials/swiftui/creating-a-watchos-app

class NotificationController: WKUserNotificationHostingController<NotificationView> {
  var title: String?
  var message: String?
  var verses: String?

  let versesIndexKey = "versesIndex"

  override var body: NotificationView {
    return NotificationView(title: title,
                            message: message,
                            verses: verses)
  }

  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

  override func didReceive(_ notification: UNNotification) {
    // This method is called when a notification needs to be presented.
    // Implement it if you use a dynamic notification interface.
    // Populate your dynamic notification interface as quickly as possible.

    let notificationData =
      notification.request.content.userInfo as? [String: Any]

    let aps = notificationData?["aps"] as? [String: Any]
    let alert = aps?["alert"] as? [String: Any]

    title = alert?["title"] as? String
    message = alert?["body"] as? String
    verses = notificationData?[versesIndexKey] as? String
  }
}
