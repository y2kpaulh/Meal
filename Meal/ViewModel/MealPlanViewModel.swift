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
        "group.com.echadworks.meal.plan"
    )!
  }
}

class MealPlanViewModel: ObservableObject {
  @Published var planList: [Plan] = []
  @Published var todayPlan: Plan = Plan(day: "", book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)
  @Published var todayPlanData: PlanData = PlanData(book: "", verses: [], verseNum: [])
  @Published var isLoading = false
  @Published var planDataError: Bool = false
  @Published var todayPlanDate: String = ""
  @Published var showingServerErrorAlert = false

  var widgetPlans: [NotiPlan] = []

  var cancelBag = Set<AnyCancellable>()

  init() {
    isLoadingPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isLoading, on: self)
      .store(in: &cancelBag)
  }

  private var isLoadingPublisher: AnyPublisher<Bool, Never> {
    self.$isLoading
      .receive(on: RunLoop.main)
      .map { $0 }
      .eraseToAnyPublisher()
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
    DispatchQueue.main.async {
      self.isLoading = true
    }

    if let mealPlan = try? readMealPlanFile(fileName: "mealPlan"),
       mealPlan.filter({ $0.day == PlanStore().getDateStr() }).count > 0 {
      self.loadPlanData(mealPlan)
      return
    }

    PlanService.requestPlan(.planList)
      .mapError({ [weak self] (error) -> Error in
        guard let self = self else { return  error }
        print(error)
        DispatchQueue.main.async {
          self.isLoading = false
          self.showingServerErrorAlert = true
        }
        return error
      })
      .sink(receiveCompletion: { [weak self] completion in
        guard let self = self else { return }
        if case .failure(let err) = completion {
          print("Retrieving data failed with error \(err)")
          DispatchQueue.main.async {
            self.planDataError = true
            self.isLoading = false
            self.showingServerErrorAlert = true
          }
        }
      },
      receiveValue: { [weak self] in
        guard let self = self else { return }
        if (try? $0.saveToFile("mealPlan")) != nil {
          DispatchQueue.main.async() {
            self.isLoading = false
          }
          if let mealPlan = try? readMealPlanFile(fileName: "mealPlan"),
             mealPlan.filter({ $0.day == PlanStore().getDateStr() }).count > 0 {
            self.loadPlanData(mealPlan)
            return
          }
        }
      })
      .store(in: &cancelBag)
  }

  func loadPlanData(_ mealPlan: [Plan]) {
    self.planList = mealPlan

    self.todayPlan = mealPlan.filter { $0.day == PlanStore().getDateStr() }[0]
    self.todayPlanData = PlanStore().getPlanData(self.todayPlan)
    self.todayPlanDate = PlanStore().convertDateToStr()
  }

  func changePlanIndex(index: Int) {
    let indexPlan = self.planList[index]
    let indexPlanData = PlanStore().getPlanData(indexPlan)
    let indexDate = PlanStore().dateFormatter.date(from: indexPlan.day)!
    let indexDateStr = PlanStore().convertDateToStr(date: indexDate)

    self.todayPlan = indexPlan
    self.todayPlanData = indexPlanData
    self.todayPlanDate = indexDateStr
  }
}
