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

    //    @StateObject var planStore = PlanStore()
    @StateObject var networkReachability = NetworkReachability()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkReachability)
//                .environmentObject(planStore)
                .onAppear {
//                  print(FileManager.documentURL ?? "")
                    
//                    for fontFamily in UIFont.familyNames {
//                        for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
//                            print(fontName)
//                        }
//                    }
                }
                .onOpenURL { url in // URL handling
                    
                }
        }
    }
}
