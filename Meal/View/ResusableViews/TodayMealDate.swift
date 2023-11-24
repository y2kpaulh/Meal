//
//  TodayMealDate.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct TodayMealDate: View {
  @Binding var date: String

  var body: some View {
    Text(date)
      .foregroundStyle(.gray)
  }
}
