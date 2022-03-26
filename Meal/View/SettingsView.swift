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
      ScrollViewReader { _ in
        ScrollView {
          LazyVStack {
            ForEach(0..<self.viewModel.settingsList.count, id: \.self) { index in
              let setting = self.viewModel.settingsList[index]

              SettingsListCell {
                //   Text("\(setting.item)")

              }
              //              .id(index)
              //              .padding(10)
              //              .onTapGesture {
              //                Swift.print("tap index \(index)")
              //              }
            }
          }
          .onAppear {
          }
        }
      }
      .listVerticalShadow()
    }

  }
}
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
