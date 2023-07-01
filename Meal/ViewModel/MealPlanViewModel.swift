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
  @Published var readingPlan: [DailyReading] = []

  @Published var todayReading: DailyReading = DailyReading(day: "", meal: Scripture(book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0), readThrough: [Scripture(book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)])

  @Published var mealWord: Word = Word(book: "", verses: [])

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

    if let readingPlan = try? readReadingPlanFile(fileName: "readingPlan"),
       readingPlan.filter({ $0.day == PlanStore().getDateStr() }).count > 0 {
      self.loadReadingPlanData(readingPlan)
      return
    }

    PlanService.requestPlan(.readingPlan)
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

        if (try? $0.saveToFile("readingPlan")) != nil {
          self.loadReadingPlanData($0)
          DispatchQueue.main.async() {
            self.isLoading = false
          }
        }
      })
      .store(in: &cancelBag)
  }

  func loadReadingPlanData(_ dailyPlan: [DailyReading]) {
    self.readingPlan = dailyPlan
    self.todayReading = self.readingPlan.filter { $0.day == PlanStore().getDateStr() }[0]
    self.mealWord = PlanStore().getMealWord(self.todayReading.meal)
    self.todayPlanDate = PlanStore().convertDateToStr()
  }

  func loadPlanData(_ readingPlan: [DailyReading]) {
    self.readingPlan = readingPlan

    self.todayReading = readingPlan.filter { $0.day == PlanStore().getDateStr() }[0]
    self.mealWord = PlanStore().getMealWord(self.todayReading.meal)
    self.todayPlanDate = PlanStore().convertDateToStr()
  }

  func changePlanIndex(index: Int) {
    let indexPlan = self.readingPlan[index]
    let indexPlanData = PlanStore().getMealWord(indexPlan.meal)
    let indexDate = PlanStore().dateFormatter.date(from: indexPlan.day)!
    let indexDateStr = PlanStore().convertDateToStr(date: indexDate)

    self.todayReading = indexPlan
    self.mealWord = indexPlanData
    self.todayPlanDate = indexDateStr
  }
}
