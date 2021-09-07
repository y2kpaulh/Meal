//
//  TodayVersesList.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct TodayVersesList<T: View>: View {
  let content: T

  init(@ViewBuilder content: () -> T) {
    self.content = content()
  }

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {
        content
      }
    }
    .listVerticalShadow()
  }
}
