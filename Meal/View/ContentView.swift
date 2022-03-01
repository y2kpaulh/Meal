//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import PartialSheet

struct ContentView: View {
  var body: some View {
    NavigationView {
      TodayMealView()
        //.navigationBarTitle("")
        .navigationBarHidden(true)
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .attachPartialSheetToRoot()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
