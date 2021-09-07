//
//  TodayMealView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI
import Combine

struct TodayMealView: View {
  @EnvironmentObject var viewModel: MealPlanViewModel
  @StateObject var networkReachability = NetworkReachability()
  @State private var isPresented = false

  var body: some View {
    TodayWordsBgView {
      self.mainView
    }
    .onAppear {
      viewModel.fetchPlanData()
    }
  }
}

struct TodayMealView_Previews: PreviewProvider {
  static var previews: some View {
    TodayMealView()
  }
}

extension TodayMealView {
  var titleLabelView: some View {
    MealTitleLabel(size: 80, textColor: Color(UIColor.label))
  }

  var headerTitleView: some View {
    HStack(alignment: .center) {
      self.titleLabelView
      self.todayMealDateView
      self.planListButton
    }
    .padding(.top, 10)
  }

  var planListButton: some View {
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

  var headerDetailView: some View {
    VStack {
      HStack {
        Text(PlanStore().getMealPlanStr(plan: viewModel.todayPlan))
          .foregroundColor(Color(UIColor.label))
          .font(.custom("NanumMyeongjoOTFBold", size: 20))
      }

      Divider()
        .foregroundColor(Color(UIColor.label))
        .padding([.leading, .trailing], 20)
        .padding(.bottom, 10)
    }
  }

  var headerView: some View {
    VStack {
      self.headerTitleView
      self.headerDetailView
    }
  }

  var todayMealDateView: some View {
    TodayMealDate(date: $viewModel.todayPlanDate)
  }

  var footerView: some View {
    Color.clear
      .frame(width: .infinity, height: 10, alignment: .center)
  }

  var todayWordsView: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {
        ForEach(0..<viewModel.todayPlanData.verses.count, id: \.self) { index in

          HStack(alignment: .top) {
            //verse number
            VerseNumberView(todayPlan: $viewModel.todayPlan, index: index)
            //verse text
            VerseTextView(todayPlanData: $viewModel.todayPlanData, index: index)
          }
          .padding([.leading, .trailing], 20)
          .padding(.bottom, 10)
          .id(index)
        }
        .redacted(reason: viewModel.loading ? .placeholder : [])
      }
    }
    .listVerticalShadow()
  }

  var alertView: some View {
    Group {
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

  var mainView: some View {
    VStack {
      //header view
      self.headerView

      //today words
      self.todayWordsView

      //footer view
      self.footerView

      //alert routine
      self.alertView
    }
  }

  func didDismiss() {
    // Handle the dismissing action.
  }
}