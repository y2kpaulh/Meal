//
//  MealApp.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/06.
//

import SwiftUI

@main
struct MealApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
