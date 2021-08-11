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
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    // We have permission!
                }
        }
    }
    
    func addNotification(title: String, subtitle: String = "", body: String = "") -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title, subtitle: subtitle, body: body))
    }
    
    func schedule() -> Void {
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
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = notification.subtitle
            content.body = notification.body
            content.summaryArgument = "Inpyo Hong"
            content.summaryArgumentCount = 40
            
            var date = DateComponents()
            date.hour = 6
            date.minute = 0
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
}
