//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject var viewModel: MealPlanViewModel
  @StateObject var networkReachability = NetworkReachability()
  @State private var isPresented = false

  init() {
    UITableView.appearance().backgroundColor = .clear
    UITableViewCell.appearance().backgroundColor = .clear
  }

  var body: some View {
    ZStack {
      //Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)

      GeometryReader { _ in
        RoundedRectangle(cornerRadius: 24, style: .continuous)
          .fill(Color(UIColor.systemBackground))
          .shadow(color: .mealTheme, radius: 10)

        VStack {
          HStack(alignment: .center) {
            MealTitleLabel(size: 80, textColor: Color(UIColor.label))

            Text(PlanStore().convertDateToStr())
              .foregroundColor(.gray)

            Button(action: { isPresented.toggle() }) {
              Image(systemName: "line.horizontal.3.decrease.circle")
                .renderingMode(.template)
                .accessibilityLabel(Text("끼니 말씀 일정표"))
                .foregroundColor(Color(UIColor.label))
            }
            .sheet(isPresented: $isPresented,
                   onDismiss: didDismiss) {
              MealPlanList(planList: $viewModel.planList)
            }
          }
          .padding(.top, 10)

          VStack {
            HStack {
              Text(PlanStore().getMealPlanStr(plan: viewModel.todayPlan))
                .foregroundColor(Color(UIColor.label))
                .font(.custom("NanumMyeongjoOTFBold", size: 20))
            }
            Rectangle()
              .fill(Color(UIColor.systemBackground))
              .frame(height: 0.5)
          }

          Divider()
            .foregroundColor(Color(UIColor.label))
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 10)

          ScrollView {
            LazyVStack(alignment: .leading) {
              ForEach(0..<viewModel.todayPlanData.verses.count, id: \.self) { index in

                HStack(alignment: .top) {
                  if viewModel.todayPlan.fChap == viewModel.todayPlan.lChap {
                    Text("\(index + viewModel.todayPlan.fVer)")
                      .foregroundColor(.gray)
                  } else {
                    if let planBook = BibleStore.books.filter { $0.abbrev == viewModel.todayPlan.book }.first {
                      let verseIndex = index + viewModel.todayPlan.fVer

                      let fChapterCount = planBook.chapters[viewModel.todayPlan.fChap - 1].count

                      Text("\(verseIndex > fChapterCount ? verseIndex - fChapterCount : verseIndex)")
                        .foregroundColor(.gray)
                    }
                  }

                  Text(viewModel.todayPlanData.verses[index])
                    .foregroundColor(.mealTheme)
                    .font(.custom("NanumMyeongjoOTF", size: 20))
                    .padding(.top, 4)
                    .id(index)
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

          Color.clear
            .frame(width: .infinity, height: 10, alignment: .center)
        }

        //.padding(.all, proxy.size.width * 0.05 / 2)
      }
      .padding()

      if viewModel.loading && networkReachability.reachable {
        ActivityIndicator()
      }

      if !networkReachability.reachable {
        Text("서버 연결 오류가 발생했습니다.\n네트워크 연결 상태를 확인해주세요.")
          .multilineTextAlignment(.center)
          .foregroundColor(.gray)
          .padding()
      } else if viewModel.planDataError {
        Text("오늘 날짜의 끼니 말씀을 찾을수 없습니다.")
      }
    }
  }

  func didDismiss() {
    // Handle the dismissing action.
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
