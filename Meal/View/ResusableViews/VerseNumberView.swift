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

  var body: some View {
    Group {
      if todayPlan.fChap == todayPlan.lChap {
        Text("\(index + todayPlan.fVer)")
          .foregroundColor(.gray)
      } else {
        if let planBook = BibleStore.books.filter { $0.abbrev == todayPlan.book }.first {
          let verseIndex = index + todayPlan.fVer

          let fChapterCount = planBook.chapters[todayPlan.fChap - 1].count

          Text("\(verseIndex > fChapterCount ? verseIndex - fChapterCount : verseIndex)")
            .foregroundColor(.gray)
        }
      }
    }
  }
}

struct VerseNumberView_Previews: PreviewProvider {
  static var previews: some View {
    VerseNumberView(todayPlan: .constant(Plan(day: "2021-09-07", book: "창", fChap: 1, fVer: 1, lChap: 1, lVer: 10)), index: 0)
  }
}
