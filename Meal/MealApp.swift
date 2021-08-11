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
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @Environment(\.scenePhase) private var scenePhase
  @StateObject var networkReachability = NetworkReachability()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(networkReachability)
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
  }
}
