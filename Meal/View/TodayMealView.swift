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
import Popovers
import PopupView

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
  @State private var currentItemIndex: Int?
  @State private var verseIndex: VerseIndex?

  @State var selection: String = "swatch_shipcove"

  let activePhaseNotification = NotificationCenter.default
    .publisher(for: .activePhaseNotification)
  let changedDayNotification = NotificationCenter.default
    .publisher(for: .changedDayNotification)

  var body: some View {
    VStack(spacing: -20) {
      TodayWordsBgView {
        self.mainView
      }
      .onAppear {
        viewModel.fetchPlanData()
      }
      .onReceive(activePhaseNotification) { _ in
        //viewModel.fetchPlanData()
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
        Text(PlanStore().getMealPlanStr(viewModel.todayPlan))
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

  var todayWordsView: some View {
    ScrollViewReader { scrollView in
      ScrollView {
        LazyVStack(alignment: .leading) {
          ForEach(0..<viewModel.todayPlanData.verses.count, id: \.self) { index in
            HStack(alignment: .firstTextBaseline) {
              //verse number
              VerseNumberView(todayPlan: $viewModel.todayPlan, index: index)
              //verse text
              if viewModel.todayPlanData.verses.indexExists(index), viewModel.todayPlanData.verses[index].count > 0 {
                VerseTextView(verse: viewModel.todayPlanData.verses[index])
              } else {
                VerseTextView(verse: "")
              }
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 10)
            .id(index)
            .onTapGesture(perform: {
              self.currentItemIndex = index
              self.verseIndex = VerseIndex(index: index, date: viewModel.todayPlan.day)
            })
            .preference(key: VerseIndexPreferenceKey.self, value: self.verseIndex)
            .popover(
              present: self.makeIsPresented(index: index),
              attributes: {
                $0.sourceFrameInset.top = -8
                $0.position = .absolute(
                  originAnchor: .top,
                  popoverAnchor: .bottom
                )
              }
            ) {
              //              Templates.Container {
              //                ColorSwatchView(selection: $selection)
              //              }
              //              .frame(maxWidth: 150, maxHeight: 10)
              if self.currentItemIndex != nil {
                Text(viewModel.todayPlanData.verses[self.currentItemIndex!])

              }

            }
          }
          .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
        .onReceive(changedDayNotification) { _ in
          scrollView.scrollTo(0, anchor: .top)
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

  func makeIsPresented(index: Int) -> Binding<Bool> {
    return .init(get: {
      return self.currentItemIndex == index
    }, set: { _ in
      self.currentItemIndex = nil
    })
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

struct VerseIndexPreferenceKey: PreferenceKey {
  static var defaultValue: VerseIndex?

  static func reduce(value: inout VerseIndex?, nextValue: () -> VerseIndex?) {
    value = nextValue()
  }
}

struct VerseIndex: Equatable, Identifiable {
  let id = UUID()

  let index: Int
  let date: String

  static func == (lhs: VerseIndex, rhs: VerseIndex) -> Bool {
    lhs.id == rhs.id
  }
}
