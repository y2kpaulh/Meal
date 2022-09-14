//
//  AppDelegate.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/09.
//

import Foundation
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseCrashlytics
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: UIResponder, UIApplicationDelegate {

  let gcmMessageIDKey = "gcm.message_id"
  let aps = "aps"
  let data1Key = "DATA1"
  let data2Key = "DATA2"

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    print(#function)
    FirebaseApp.configure()
    Crashlytics.crashlytics()

    Messaging.messaging().delegate = self

    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    application.registerForRemoteNotifications()

    Auth.auth().signIn(withEmail: "y2kpaulh@gmail.com", password: "123456") { [weak self] authResult, _ in
      guard let strongSelf = self else { return }
      if let user = authResult?.user {
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        let uid = user.uid
        let email = user.email
        let photoURL = user.photoURL
        let displayName = user.displayName

        var multiFactorString = "MultiFactor: "
        for info in user.multiFactor.enrolledFactors {
          multiFactorString += info.displayName ?? "[DispayName]"
          multiFactorString += " "
        }
        // ...
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Inpyo Hong"
        changeRequest?.commitChanges { _ in
          // ...
        }

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)

        docRef.getDocument { (document, _) in
          if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
          } else {
            print("Document does not exist")
          }

          if let memo = document?["memo"] as? String {
            print("memo", memo)
          }
        }
      }
    }

    return true
  }

  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                    -> Void) {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo["gcm.message_id"] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    completionHandler(UIBackgroundFetchResult.newData)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    print("\(#function) apnsToken: \(String(describing: deviceToken))")

  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo
    // Print full message.
    print(userInfo)

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    if let data1 = userInfo[data1Key] {
      print("data1: \(data1)")
    }
    if let data2 = userInfo[data2Key] {
      print("data2: \(data2)")
    }
    if let apnsData = userInfo[aps] {
      print("apnsData: \(apnsData)")
    }

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken!))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: NSNotification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
}
