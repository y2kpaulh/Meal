//
//  TodayWordsBgView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct TodayWordsBgView<T: View>: View {
  let content: T

  var roundedCornerBgView: some View {
    RoundedRectangle(cornerRadius: 24, style: .continuous)
      .fill(Color(UIColor.systemBackground))
      .shadow(color: .mealTheme, radius: 10)
  }

  init(@ViewBuilder content: () -> T) {
    self.content = content()
  }

  var body: some View {
    ZStack {
      roundedCornerBgView
      VStack {
        content
      }
    }
    .padding()
  }
}
