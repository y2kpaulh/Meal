//
//  ContentView.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/06.
//

import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject var viewModel: MealPlanViewModel

  var body: some View {
    VStack {
      VStack {
        HStack(alignment: .center) {
          Text("끼니")
            .foregroundColor(.white)
            .font(.custom("NanumBrushOTF", size: 40))

          Text(PlanStore().convertDateToStr())
            .foregroundColor(.gray)
        }
        .padding(.top, 10)

        Text(PlanStore().getMealPlanStr(plan: viewModel.todayPlan))
      }

      Divider()
        .foregroundColor(Color.white)

      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(Array(viewModel.todayPlanData.verses.enumerated()), id: \.1) { index, verse in
            HStack(alignment: .top) {
              if viewModel.todayPlan.fChap == viewModel.todayPlan.lChap {
                Text("\(index + viewModel.todayPlan.fVer)")
                  .foregroundColor(.gray)
                  .font(.footnote)

              } else {
                if let planBook = BibleStore.books.filter { $0.abbrev == viewModel.todayPlan.book }.first {
                  let verseIndex = index + viewModel.todayPlan.fVer

                  let fChapterCount = planBook.chapters[viewModel.todayPlan.fChap - 1].count

                  Text("\(verseIndex > fChapterCount ? verseIndex - fChapterCount : verseIndex)")
                    .foregroundColor(.gray)
                }
              }

              Text(verse)
                .font(.custom("NanumMyeongjoOTF", size: 14))
                .foregroundColor(.white)
                .padding(.top, 4)
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 10)
          }
          .redacted(reason: viewModel.loading ? .placeholder : [])
        }
        .onAppear {
          viewModel.fetchPlanData()
        }
      }
      .listVerticalShadow()
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
