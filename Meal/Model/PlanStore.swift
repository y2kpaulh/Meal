//
//  PlanStore.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation
import Combine

class PlanStore: ObservableObject {
    static let planUrl = "https://api.jsonbin.io/b/60f298aa0cd33f7437ca62e2/1"
    let url = URL(string: planUrl)!
    var cancelables = Set<AnyCancellable>()

    @Published var planList: [Plan] = []
    @Published var todayPlan: Plan?
    @Published var todayPlanData: PlanData?
    @Published var planDataError: Bool = false
    @Published var loading = false

    var todayStr: String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: nowDate)
    }
    
    init() {
       getTodayPlan()
    }
    
    func mealPlan() -> AnyPublisher<Meal, Never> {
        URLSession.shared
            .dataTaskPublisher(for: self.url)
            .receive(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: Meal.self, decoder: JSONDecoder())
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
                let todayPlan = object.plan.filter{ $0.day == self.todayStr }
                guard todayPlan.count > 0 else { return }
                self.todayPlan = todayPlan[0]
                self.todayPlanData = self.getTodayPlanData()
                
                DispatchQueue.main.async {
                    self.loading = false
                }
            })
            .store(in: &cancelables)
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
    
    func getTodayPlanData() -> PlanData? {
        guard let todayPlan = self.todayPlan else { return nil }
        
        let book = BibleStore.books.filter { $0.abbrev == todayPlan.book }

        guard book.count > 0,
              let planBook = book.first,
              let index = BibleStore.books.firstIndex(where: { $0.abbrev == todayPlan.book })
              else { return nil }

        let title = BibleStore.titles[index]
        var verse = [String]()
        
        if todayPlan.sChap == todayPlan.fChap {
            let chapter = planBook.chapters[todayPlan.sChap-1]

            let verseRange = chapter[todayPlan.sVer-1..<todayPlan.fVer]
            
            verse = Array(verseRange)
        }
        else{
            let sChapter = planBook.chapters[todayPlan.sChap-1]
            let fChapter = planBook.chapters[todayPlan.fChap-1]
            
            let sVerseRange = sChapter[todayPlan.sVer-1..<sChapter.count]
            let fVerseRange = fChapter[0..<todayPlan.fVer]

            verse = Array(sVerseRange + fVerseRange)
        }
        
        return PlanData(book: title, verses: verse)
    }
    
    func todayDateStr() -> String {
        let date = NSDate()
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
