//
//  TodayPlan.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

struct TodayPlan: View {
  @EnvironmentObject var viewModel: MealPlanViewModel

  var body: some View {
    VStack {
      WatchHeaderView(todayPlan: $viewModel.todayReadingPlan)

      Divider()
        .foregroundColor(Color.white)

      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(0..<viewModel.todayMealPlanData.verses.count, id: \.self) { index in
            HStack(alignment: .top) {
              if viewModel.todayReadingPlan.meal.fChap == viewModel.todayReadingPlan.meal.lChap {
                Text("\(index + viewModel.todayReadingPlan.meal.fVer)")
                  .foregroundColor(.gray)
                  .font(.footnote)

              } else {
                if let planBook = BibleStore.books.filter { $0.abbrev == viewModel.todayReadingPlan.meal.book }.first {
                  let verseIndex = index + viewModel.todayReadingPlan.meal.fVer

                  let fChapterCount = planBook.chapters[viewModel.todayReadingPlan.meal.fChap - 1].count

                  Text("\(verseIndex > fChapterCount ? verseIndex - fChapterCount : verseIndex)")
                    .foregroundColor(.gray)
                }
              }

              Text(viewModel.todayMealPlanData.verses[index])
                .font(.custom("NanumMyeongjoOTF", size: 16))
                .foregroundColor(.white)
                .padding(.top, 4)
            }
            .padding([.leading, .trailing], 8)
            .padding(.bottom, 10)
            .id(index)
          }
          //.redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
        .onAppear {
          viewModel.fetchPlanData()
        }
      }
      .listVerticalShadow()
    }

  }
}

struct TodayPlan_Previews: PreviewProvider {
  static var previews: some View {
    TodayPlan()
  }
}
