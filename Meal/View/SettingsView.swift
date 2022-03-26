//
//  SettingsView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/03/20.
//

import SwiftUI
import Combine

struct SettingsView: View {
  @StateObject var viewModel = SettingsViewModel()

  var body: some View {
    VStack {
      Text("Value")
    }
    .frame(width: UIScreen.main.bounds.width, height: 500)
    .background(Color.red)
  }
}
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
