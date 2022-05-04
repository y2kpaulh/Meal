//
//  SettingsView.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/03/20.
//

import SwiftUI
import Combine

struct SettingsView: View {
  let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  @State private var isPresented = false
  @EnvironmentObject var viewModel: MealPlanViewModel
  @State private var dailyNotiTime: Date = AppSettingsManager.dailyNotiSettingsTimeFormatter.date(from: AppSettings.stringValue(.dailyNotiTime)!)!
  @State private var isToggleOn: Bool = UIApplication.shared.isRegisteredForRemoteNotifications//UserDefaults.standard.bool(forKey: "isDailyNoti")
    
    init() {
        let isPushOn = UIApplication.shared.isRegisteredForRemoteNotifications
        
        if isPushOn {
            print("push on")
        } else {
            print("push off")
        }
    }
    
  var body: some View {
    Form {
      Section(header: Text("버전 정보"), content: {
        VStack(alignment: .leading) {
          Text(version)
        }
      })

      Section(header: Text("알림 설정")) {

        Toggle("사용", isOn: $isToggleOn)
          .onChange(of: isToggleOn) { _ in
            Swift.print("isToggleOn", isToggleOn)
            AppSettings[.isDailyNoti] = isToggleOn
            Swift.print("AppSettings.boolValue(.isDailyNoti)", AppSettings.boolValue(.isDailyNoti))

            if isToggleOn {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                UIApplication.shared.registerForRemoteNotifications()
                AppSettings[.dailyNotiTime] = AppSettingsManager.dailyNotiSettingsTimeFormatter.string(from: dailyNotiTime)
                PlanStore().registDailyPush()
            } else {
                UIApplication.shared.unregisterForRemoteNotifications()
                PlanStore().clearDailyPush()
            }
          }

        if isToggleOn {
          DatePicker("알림 시간",
                     selection: $dailyNotiTime,
                     displayedComponents: .hourAndMinute)
            .onChange(of: dailyNotiTime, perform: { _ in
              AppSettings[.dailyNotiTime] = AppSettingsManager.dailyNotiSettingsTimeFormatter.string(from: dailyNotiTime)
              PlanStore().registDailyPush()
            })
            .environment(\.locale, Locale(identifier: "ko"))
        }
      }

      Section(header: Text("저작권"), content: {
        VStack(alignment: .leading) {
          Text("개역개정판 성경 번역본은 대한성서공회의 허락을 받고 사용하였습니다")
        }
        .frame(height: 80)
      })

    }
    .frame(height: 400)
  }

  func didDismiss() {
    // Handle the dismissing action.
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
