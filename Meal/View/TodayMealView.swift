//
//  TodayMealView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/07.
//

import SwiftUI
import Combine
import PartialSheet
import UIKit
import Parchment

struct TodayMealView: View {
  @Environment(\.verticalSizeClass) var
    verticalSizeClass: UserInterfaceSizeClass?
  @Environment(\.horizontalSizeClass) var
    horizontalSizeClass: UserInterfaceSizeClass?
  var isIPad: Bool {
    horizontalSizeClass == .regular &&
      verticalSizeClass == .regular
  }

  @StateObject var viewModel = MealPlanViewModel()
  @StateObject var networkReachability = NetworkReachability()
  @State private var isPlanViewPresented = false
  @State private var isSettingsViewPresented = false

  let changedDayNotification = NotificationCenter.default
    .publisher(for: .changedDayNotification)

  let widgetDeepLinkNotification = NotificationCenter.default
    .publisher(for: .widgetDeepLinkNotification)

  let items = [
    PagingIndexItem(index: 0, title: "끼니"),
    PagingIndexItem(index: 1, title: "통독")
  ]

  var body: some View {
    VStack(spacing: -20) {
      TodayWordsBgView {
        VStack(spacing: -20) {
          self.headerView
            .frame(height: 100)
          self.mainView
        }
      }
      .onAppear {
        viewModel.fetchPlanData()

        if let result = try? JSONDecoder().decode(ReadingPlan.self, from: PlanStore().testPlan) {
          viewModel.readingPlan = result

          let resultData = PlanStore().getReadThroughWord(viewModel.readingPlan[3].readThrough)

          let resultPlan = viewModel.readingPlan[3].readThrough.enumerated().map {  (index, element) in
            var result = element
            result.lVer = resultData.lVerArr[index]
            return result
          }

          Swift.print(">>>>\n", resultData)
          Swift.print("----\n", resultPlan)
        }

      }
      .onReceive(widgetDeepLinkNotification) { _ in
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
    .textSelection(.enabled)
  }

  var planListButton: some View {
    Button(action: { isPlanViewPresented.toggle() }) {
      Image(systemName: "calendar")
        .renderingMode(.template)
        .accessibilityLabel(Text("일정"))
        .foregroundColor(Color(UIColor.label))
    }
    .sheet(isPresented: $isPlanViewPresented) {
      MealPlanList(isPresented: $isPlanViewPresented)
        .environmentObject(viewModel)
    }
    //    .partialSheet(isPresented: $isPlanViewPresented, type: .scrollView(height: 500, showsIndicators: false), iPhoneStyle: PSIphoneStyle(background: .solid(Color(UIColor.systemBackground)), handleBarStyle: .solid(.gray), cover: .enabled( Color.black.opacity(0.2)), cornerRadius: 10)
    //    ) {
    //      MealPlanList(isPresented: $isPlanViewPresented)
    //        .environmentObject(viewModel)
    //    }
  }

  var headerDetailView: some View {
    VStack {
      HStack {
        Text(PlanStore().getMealPlanStr(viewModel.todayReadingPlan.meal))
          .foregroundColor(Color(UIColor.label))
          .font(.custom("NanumMyeongjoOTFBold", size: 20))
          .textSelection(.enabled)
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
        if isIPad {
          self.ipadSettingsButton.padding()
        } else {
          self.settingsButton.padding()
        }
      }

      VStack(spacing: -20) {
        self.headerTitleView
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

  var ipadSettingsButton: some View {
    Button(action: {
            isSettingsViewPresented.toggle() }) {
      Image(systemName: "info.circle")
        .renderingMode(.template)
        .accessibilityLabel(Text("설정"))
        .foregroundColor(Color(UIColor.label))
    }
    .partialSheet(isPresented: $isSettingsViewPresented, type: .dynamic, iPadMacStyle: PSIpadMacStyle(backgroundColor: Color(UIColor.systemBackground), closeButtonStyle: PSIpadMacStyle.PSIpadMacCloseButtonStyle.none)
    ) {
      SettingsView()
    }
  }

  var todayMealDateView: some View {
    TodayMealDate(date: $viewModel.todayPlanDate)
  }

  var footerView: some View {
    Color.clear
      .frame(height: 10, alignment: .center)
  }
  var todayMealView: some View {
    ScrollViewReader { scrollView in
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(0..<viewModel.mealWord.verses.count, id: \.self) { index in
            HStack(alignment: .firstTextBaseline) {
              //verse number
              VerseNumberView(todayPlan: $viewModel.todayReadingPlan.meal, index: index)
              //verse text
              if viewModel.mealWord.verses.indexExists(index), viewModel.mealWord.verses[index].count > 0 {
                VerseTextView(verse: viewModel.mealWord.verses[index])
              } else {
                VerseTextView(verse: "")
              }
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 10)
            .id(index)
          }
        }
        //.redacted(reason: viewModel.isLoading ? .placeholder : [])
        .textSelection(.enabled)
        .onReceive(changedDayNotification) { _ in
          scrollView.scrollTo(0, anchor: .top)
        }
        .alert(isPresented: $viewModel.showingServerErrorAlert) {
          Alert(title: Text("알림"), message: Text("오늘 날짜의 끼니 말씀을 찾을수 없습니다."),
                dismissButton: .default(Text("확인")))
        }
        .onAppear {
          withAnimation {
            scrollView.scrollTo(0, anchor: .top)
          }
        }
      }
      .listVerticalShadow()
    }
  }
  var todayWordsView: some View {
    ScrollViewReader { scrollView in
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(0..<viewModel.mealWord.verses.count, id: \.self) { index in
            HStack(alignment: .firstTextBaseline) {
              //verse number
              VerseNumberView(todayPlan: $viewModel.todayReadingPlan.meal, index: index)
              //verse text
              if viewModel.mealWord.verses.indexExists(index), viewModel.mealWord.verses[index].count > 0 {
                VerseTextView(verse: viewModel.mealWord.verses[index])
              } else {
                VerseTextView(verse: "")
              }
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 10)
            .id(index)
          }
        }
        //.redacted(reason: viewModel.isLoading ? .placeholder : [])
        .textSelection(.enabled)
        .onReceive(changedDayNotification) { _ in
          scrollView.scrollTo(0, anchor: .top)
        }
        .alert(isPresented: $viewModel.showingServerErrorAlert) {
          Alert(title: Text("알림"), message: Text("오늘 날짜의 끼니 말씀을 찾을수 없습니다."),
                dismissButton: .default(Text("확인")))
        }
        .onAppear {
          withAnimation {
            scrollView.scrollTo(0, anchor: .top)
          }
        }
      }
      .listVerticalShadow()
    }
  }

  var alertView: some View {
    Group {
      //      if viewModel.isLoading && networkReachability.reachable {
      //        ActivityIndicator()
      //      }

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
    var option = PagingOptions()
    option.menuItemSize = .sizeToFit(minWidth: 150, height: 40)
    option.borderOptions = .hidden

    return VStack {
      PageView(options: option, items: items) { item in
        VStack {
          Text("\(item.index)" + item.title)
          self.headerDetailView

          if item.index == 0 {
            //todayMealView
            self.todayMealView
          } else {
            //today words
            self.todayWordsView
              .background(Color.red)
          }

          //footer view
          self.footerView
        }
      }
      .padding([.horizontal], 2)
      .padding([.bottom], 14)
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
