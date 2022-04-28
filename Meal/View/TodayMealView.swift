//
//  TodayMealView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI
import Combine
import PartialSheet

struct TodayMealView: View {
  @StateObject var viewModel = MealPlanViewModel()
  @StateObject var networkReachability = NetworkReachability()
  @State private var isPlanViewPresented = false
  @State private var isSettingsViewPresented = false

  let activePhaseNotification = NotificationCenter.default
    .publisher(for: .activePhaseNotification)

  var body: some View {
    VStack(spacing: -20) {
      TodayWordsBgView {
        self.mainView
      }
      .onAppear {
        viewModel.fetchPlanData()
      }
      .onReceive(activePhaseNotification) { _ in
        viewModel.fetchPlanData()
      }
    }

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
    .padding(.top, 30)

  }

  var planListButton: some View {
    Button(action: { isPlanViewPresented.toggle() }) {
      Image(systemName: "calendar")
        .renderingMode(.template)
        .accessibilityLabel(Text("일정"))
        .foregroundColor(Color(UIColor.label))
    }
    .partialSheet(isPresented: $isPlanViewPresented, type: .scrollView(height: 500, showsIndicators: false), iPhoneStyle: PSIphoneStyle(background: .solid(Color(UIColor.systemBackground)), handleBarStyle: .solid(.gray), cover: .enabled( Color.black.opacity(0.2)), cornerRadius: 10)
    ) {
      MealPlanList(isPresented: $isPlanViewPresented)
        .environmentObject(viewModel)
    }
  }

  var headerDetailView: some View {
    VStack {
      HStack {
        Text(PlanStore().getMealPlanStr(viewModel.todayPlan))
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
    VStack(spacing: -60) {
      HStack {
        Spacer()
        self.settingsButton.padding()
      }

      VStack(spacing: -20) {
        self.headerTitleView
        self.headerDetailView
      }
    }
  }

  var settingsButton: some View {
    Button(action: {
            isSettingsViewPresented.toggle() }) {
      Image(systemName: "info.circle")
        .renderingMode(.template)
        .accessibilityLabel(Text("설정"))
        .foregroundColor(Color(UIColor.label))
    }
    .partialSheet(isPresented: $isSettingsViewPresented, type: .dynamic, iPhoneStyle: PSIphoneStyle(background: .solid(Color(UIColor.systemBackground)), handleBarStyle: .solid(.gray), cover: .enabled( Color.black.opacity(0.2)), cornerRadius: 10)
    ) {
      SettingsView()
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
          HStack(alignment: .firstTextBaseline) {
            //verse number
            VerseNumberView(todayPlan: $viewModel.todayPlan, index: index)
            //verse text
            VerseTextView(todayPlanData: $viewModel.todayPlanData, index: index)
          }
          .padding([.leading, .trailing], 20)
          .padding(.bottom, 10)
          .id(index)
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
      }
    }
    .listVerticalShadow()
  }

  var alertView: some View {
    Group {
      if viewModel.isLoading && networkReachability.reachable {
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
    ZStack {
      VStack {
        //header view
        self.headerView

        //today words
        self.todayWordsView

        //footer view
        self.footerView
      }
      //alert routine
      //self.alertView
    }
  }

  func didDismiss() {
    // Handle the dismissing action.
  }
}

struct TodayMealView_Previews: PreviewProvider {
  static var previews: some View {
    TodayMealView()
  }
}
