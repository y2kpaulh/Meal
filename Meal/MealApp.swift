//
//  MealApp.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import Combine

@main
struct MealApp: App {
  #if !os(watchOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  #endif
  @Environment(\.scenePhase) private var scenePhase

  init() {
    AppSettings.setDefaultValue()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        //.environmentObject(viewModel)
        .onAppear {
          //          print(FileManager.documentURL ?? "")
          //          for fontFamily in UIFont.familyNames {
          //            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
          //              print(fontName)
          //            }
          //          }
        }
        .onOpenURL { url in // URL handling
          print("open URL", url)
          if url.absoluteString == AppSettings.widgetDeepLinkURL.absoluteString {
            NotificationCenter.default.post(name: .widgetDeepLinkNotification, object: nil)
          }
        }
    }

    #if os(watchOS)
    WKNotificationScene(controller: NotificationController.self, category: "MealPlan")
    #endif
  }
}
