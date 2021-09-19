//
//  VerseTextView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct VerseTextView: View {
  @Binding var todayPlanData: PlanData
  var index: Int

  var body: some View {
    Text(todayPlanData.verses[index])
      .lineSpacing(6)
      .foregroundColor(.mealTheme)
      .font(.custom("NanumMyeongjoOTF", size: 20))
      .padding(.top, 4)
      .id(index)
  }
}

struct VerseTextView_Previews: PreviewProvider {
  static var previews: some View {
    VerseTextView(todayPlanData: .constant(PlanData(book: "마", verses: [""])), index: 0)
  }
}
