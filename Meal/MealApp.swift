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
        .onOpenURL { _ in // URL handling

        }
        .onChange(of: scenePhase) { phase in
          // change in this app's phase - composite of all scenes
          switch phase {
          case .active:
            //changedToActive()
            print("active")
            NotificationCenter.default.post(name: .activePhaseNotification, object: nil)

          case .background:
            //changedToBackground()
            print("background")

          case .inactive:
            //changedToInactive()
            print("inactive")

          default:
            break
          }
        }
    }

    #if os(watchOS)
    WKNotificationScene(controller: NotificationController.self, category: "MealPlan")
    #endif
  }
}
