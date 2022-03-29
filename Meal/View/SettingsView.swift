//
//  SettingsView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/03/20.
//

import SwiftUI
import Combine

struct SettingsView: View {
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach(1...100, id: \.self, content: SampleRow.init)
      }
    }
    .frame(height: 300)
  }
}

struct SampleRow: View {
  let id: Int

  init(id: Int) {
    self.id = id
    print("Loading row \(id)")
  }

  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 10) {
        Spacer()
          .frame(width: 1)
        Text("Row \(id)")
          .font(.system(size: 14, weight: .semibold, design: .default))
        Spacer()

      }
      Divider()
    }
    .frame(width: UIScreen.main.bounds.width - 20, height: 40)

  }

}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
