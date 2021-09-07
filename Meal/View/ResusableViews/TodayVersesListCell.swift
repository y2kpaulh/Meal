//
//  TodayVersesListCell.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct TodayVersesListCell<T: View>: View {
  let content: T

  init(@ViewBuilder content: () -> T) {
    self.content = content()
  }

  var body: some View {
    HStack(alignment: .top) {
      content
    }
    .padding([.leading, .trailing], 20)
    .padding(.bottom, 10)
  }
}
