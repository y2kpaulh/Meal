//
//  VerseNumberView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI

struct VerseNumberView: View {
  @Binding var todayPlan: Plan
  var index: Int
  var verseNumList: [Int]
  var body: some View {
    Group {
      if todayPlan.fChap == todayPlan.lChap {
        Text("\(index + todayPlan.fVer)")
          .foregroundColor(.gray)
      } else {
        Text("\(verseNumList[index])")
          .foregroundColor(.gray)
      }
    }
  }
}

struct VerseNumberView_Previews: PreviewProvider {
  static var previews: some View {
    VerseNumberView(todayPlan: .constant(Plan(day: "2021-09-07", book: "창", fChap: 1, fVer: 1, lChap: 1, lVer: 10)), index: 0, verseNumList: [])
  }
}
