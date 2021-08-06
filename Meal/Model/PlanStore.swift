//
//  PlanStore.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation
import Combine
import WidgetKit

class PlanStore: ObservableObject {
    static let planUrl = "https://api.jsonbin.io/b/610ba2cdf098011544ab9bd4/6"
    let url = URL(string: planUrl)!
    var cancelables = Set<AnyCancellable>()
    let dateFormatter = DateFormatter()

    @Published var planList: [Plan] = []
    @Published var todayPlan: Plan?
    @Published var todayPlanData: PlanData?
    @Published var planDataError: Bool = false
    @Published var loading = false
        
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko") // 로케일 변경
        
        getTodayPlan()
    }
    
    func mealPlan() -> AnyPublisher<Meal, Never> {
        URLSession.shared
            .dataTaskPublisher(for: self.url)
            .receive(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: Meal.self, decoder: JSONDecoder())
            .print("mealPlan")
            .replaceError(with: Meal(plan: []))
            .eraseToAnyPublisher()
    }

    func getTodayPlan() {
        loading = true
                
        mealPlan()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                    self.planDataError = true
                    
                    DispatchQueue.main.async {
                        self.loading = false
                    }
                }
            }, receiveValue: { [weak self] object in
                //print("Retrieved object \(object)")
                guard let self = self else { return }
                self.planList = object.plan
                let todayPlan = object.plan.filter{ $0.day == self.getTodayStr() }
                guard todayPlan.count > 0 else { return }
                self.todayPlan = todayPlan[0]
                self.todayPlanData = self.getTodayPlanData()
                
                WidgetCenter.shared.reloadTimelines(ofKind: "MealWidget")

                DispatchQueue.main.async {
                    self.loading = false
                }
            })
            .store(in: &cancelables)
    }
    
    func getTodayPlanData() -> PlanData? {
      guard let todayPlan = self.todayPlan else { return nil }
        
      return self.getDayPlanData(plan: todayPlan)
    }
    
    func getDayPlanData(plan: Plan)-> PlanData? {
        let book = BibleStore.books.filter { $0.abbrev == plan.book }
        
        guard book.count > 0,
              let planBook = book.first,
              let index = BibleStore.books.firstIndex(where: { $0.abbrev == plan.book })
        else { return nil }
        
        let title = BibleStore.titles[index]
        var verse = [String]()
        
        if plan.fChap == plan.lChap {
            let chapter = planBook.chapters[plan.fChap-1]
            
            let verseRange = chapter[plan.fVer-1..<plan.lVer]
            
            verse = Array(verseRange)
        }
        else{
            let fChapter = planBook.chapters[plan.fChap-1]
            let lChapter = planBook.chapters[plan.lChap-1]
            
            let fVerseRange = fChapter[plan.fVer-1..<fChapter.count]
            let lVerseRange = lChapter[0..<plan.lVer]
            
            verse = Array(fVerseRange + lVerseRange)
        }
        
        return PlanData(book: title, verses: verse)
    }
}

extension PlanStore {
    //    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
    //        guard
    //            let response = output.response as? HTTPURLResponse,
    //            response.statusCode >= 200 && response.statusCode < 300 else {
    //                throw URLError(.badServerResponse)
    //            }
    //        return output.data
    //    }
    func getTodayStr() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    func getBookTitle(book: String) -> String? {
        guard let index = BibleStore.books.firstIndex(where: { $0.abbrev == book })
        else { return nil }
        
        let title = BibleStore.titles[index]
        
        return title
    }
    
    func convertDateToStr(date: Date = Date()) -> String {
        let monFormatter = DateFormatter()
        monFormatter.dateFormat = "MM/dd"
        
        let dateStr = monFormatter.string(from: date as Date)
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "ko") // 로케일 변경
        dayFormatter.dateFormat = "EEEE"
        
        let day = dayFormatter.string(from: date as Date)
        
        return "\(dateStr), \(day)"
    }
}
