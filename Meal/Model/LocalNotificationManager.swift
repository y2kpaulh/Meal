//
//  LocalNotificationManager.swift
//  noti
//
//  Created by Inpyo Hong on 2021/08/06.
//

import Foundation
import UserNotifications

struct Notification {
  var id: String
  var title: String
  var subtitle: String
  var body: String
  var month: Int
  var day: Int
}

class LocalNotificationManager {
  var notifications = [Notification]()

  func requestPermission() {
    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
        if granted == true && error == nil {
          // We have permission!
        }
      }
  }

  func addNotification(title: String, subtitle: String = "", body: String = "", month: Int = 0, day: Int = 0) {
    notifications.append(Notification(id: UUID().uuidString,
                                      title: title,
                                      subtitle: subtitle,
                                      body: body,
                                      month: month,
                                      day: day))
  }

  func schedule() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
      case .notDetermined:
        self.requestPermission()
      case .authorized, .provisional:
        self.scheduleNotifications()
      default:
        break
      }
    }
  }

  func removeSchedule() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }

  func scheduleNotifications() {
    let scheduleDate = AppSettingsManager.dailyNotiSettingsTimeFormatter.date(from: AppSettings.stringValue(.dailyNotiTime)!)!
    let scheduleDateStr = AppSettingsManager.dailyNotiScheduleTimeFormatter.string(from: scheduleDate)

    let timeInfo = scheduleDateStr.split(separator: ":")
    let hour: Int = Int(timeInfo[0])!
    let minute: Int = Int(timeInfo[1])!

    print(#function, hour, minute)

    for notification in notifications {
      let content = UNMutableNotificationContent()
      content.title = notification.title
      content.sound = UNNotificationSound.default
      content.subtitle = notification.subtitle
      content.body = notification.body

      var date = DateComponents()
      date.month = notification.month
      date.day = notification.day
      date.hour = hour
      date.minute = minute

      let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
      let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

      UNUserNotificationCenter.current().add(request) { error in
        guard error == nil else { return }
        //print("Scheduling notification with id: \(notification.id)")
      }
    }
  }
}
