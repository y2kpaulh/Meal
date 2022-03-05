//
//  ContentView.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/06.
//

import SwiftUI
import Combine

struct ContentView: View {
  @StateObject var viewModel = MealPlanViewModel()

  var body: some View {
    NavigationView {
      VStack(spacing: -4) {
        MealTitleLabel(size: 60, textColor: .white)

        List {
          NavigationLink(destination: TodayPlan().environmentObject(viewModel)) {
            Text("오늘의 끼니")
          }

          NavigationLink(destination: MealPlanList().environmentObject(viewModel)) {
            Text("끼니 일정표")
          }
        }
      }
      .onAppear {
        viewModel.fetchPlanData()
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
