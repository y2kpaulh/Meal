//
//  MealApp.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

@main
struct MealApp: App {
    @StateObject var bibleStore = BibleStore()
    @StateObject var planStore = PlanStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bibleStore)
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
