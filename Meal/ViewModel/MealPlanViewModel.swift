//
//  MealPlanViewModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/10.
//

import Foundation
import Combine
#if !os(watchOS)
import WidgetKit
#endif

extension FileManager {
  static func sharedContainerURL() -> URL {
    return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier:
        "group.com.epiens.meal.plan"
    )!
  }
}

class MealPlanViewModel: ObservableObject {
  @Published var planList: [Plan] = []
  @Published var todayPlan: Plan = Plan(day: "", book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)
  @Published var todayPlanData: PlanData = PlanData(book: "", verses: [])
  @Published var loading = false
  @Published var planDataError: Bool = false
  var widgetPlans: [NotiPlan] = []

  @Published var todayPlanDate: String = ""

  var cancelBag = Set<AnyCancellable>()

  init() {

  }

  func writeNotiPlan() {
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("widgetPlan.json")
    print(">>> \(archiveURL)")

    if let dataToSave = try? JSONEncoder().encode(widgetPlans) {
      do {
        try dataToSave.write(to: archiveURL)
      } catch {
        print("Error: Can't write widget plan")
      }
    }
  }
}

extension MealPlanViewModel {
  func fetchPlanData() {
    self.loading = true

    PlanService.requestPlan(.planList)
      //            .map{  //리스트에서 바로 데이터 가지고 올때 사용
      //                PlanStore().getPlanData(plan: $0.filter{ $0.day == PlanStore().getDateStr() }[0])
      //            }
      .mapError({ (error) -> Error in
        print(error)
        DispatchQueue.main.async {
          self.loading = false
        }
        return error
      })
      .sink(receiveCompletion: { [weak self] completion in
        guard let self = self else { return }

        if case .failure(let err) = completion {
          print("Retrieving data failed with error \(err)")

          self.planDataError = true
          self.loading = false
        }
      },
      receiveValue: { [weak self] in
        guard let self = self else { return }

        self.planList = $0
        self.todayPlan = $0.filter { $0.day == PlanStore().getDateStr() }[0]
        self.todayPlanData = PlanStore().getPlanData(plan: self.todayPlan)
        self.todayPlanDate = PlanStore().convertDateToStr()

        self.loading = false

        // 앱 시작시 위젯 업데이트 루틴
        //        DispatchQueue.main.async {
        //          self.widgetPlans = [NotiPlan(
        //                                day: self.todayPlan.day,
        //                                book: self.todayPlan.book,
        //                                fChap: self.todayPlan.fChap,
        //                                fVer: self.todayPlan.fVer,
        //                                lChap: self.todayPlan.lChap,
        //                                lVer: self.todayPlan.lVer,
        //                                verses: self.todayPlanData.verses)]
        //
        //          self.writeNotiPlan()
        //          WidgetCenter.shared.reloadTimelines(ofKind: "MealWidget")
        //        }

        //print($0)
      })
      .store(in: &cancelBag)
  }
}
