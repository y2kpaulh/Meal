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
    @StateObject var planStore = PlanStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(planStore)
                .onAppear {
//                  print(FileManager.documentURL ?? "")
                    
//                    for fontFamily in UIFont.familyNames {
//                        for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
//                            print(fontName)
//                        }
//                    }
                }
        }
    }
}
