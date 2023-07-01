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
  @Published var mealPlan: [MealPlan] = []
  @Published var readingPlan: [DailyPlan] = []

  @Published var todayPlan: MealPlan = MealPlan(day: "", book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)
  @Published var todayPlanData: Word = Word(book: "", verses: [])
  @Published var todaySchedule: [Scripture] = [Scripture]()

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

    PlanService.requestPlan(.mealPlan)
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
          self.loadPlanData($0)
          DispatchQueue.main.async() {
            self.isLoading = false
          }
        }
      })
      .store(in: &cancelBag)
  }

  func loadPlanData(_ mealPlan: [MealPlan]) {
    self.mealPlan = mealPlan

    self.todayPlan = mealPlan.filter { $0.day == PlanStore().getDateStr() }[0]
    self.todayPlanData = PlanStore().getPlanData(self.todayPlan)
    self.todayPlanDate = PlanStore().convertDateToStr()
  }

  func changePlanIndex(index: Int) {
    let indexPlan = self.mealPlan[index]
    let indexPlanData = PlanStore().getPlanData(indexPlan)
    let indexDate = PlanStore().dateFormatter.date(from: indexPlan.day)!
    let indexDateStr = PlanStore().convertDateToStr(date: indexDate)

    self.todayPlan = indexPlan
    self.todayPlanData = indexPlanData
    self.todayPlanDate = indexDateStr
  }
}
