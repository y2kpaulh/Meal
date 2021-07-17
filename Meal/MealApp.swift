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
    @StateObject var bibleStore = BibleStore()
    @StateObject var planStore = PlanStore()
    
    init() {
        let url = URL(string: "https://api.jsonbin.io/b/60f298aa0cd33f7437ca62e2/1")!

        let subscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Meal.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
            }, receiveValue: { object in
                print("Retrieved object \(object)")
            })

    }
    
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
