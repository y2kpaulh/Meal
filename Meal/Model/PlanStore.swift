//
//  PlanStore.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation
import Combine
import WidgetKit
import SwiftUI

extension FileManager {
    static func sharedContainerURL() -> URL {
        return FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier:
                "group.com.epiens.meal.plan"
        )!
    }
}

class PlanStore: ObservableObject {
    let manager = LocalNotificationManager()
    
    static let planUrl = "https://api.jsonbin.io/b/610ca7a3e1b0604017a77e22"
    let url = URL(string: planUrl)!
    var cancelables = Set<AnyCancellable>()
    let dateFormatter = DateFormatter()
    var widgetPlans: [NotiPlan] = []
    
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
            //.print("mealPlan")
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
                
                if let todayPlan = self.todayPlan, let todayPlanData = self.todayPlanData {
                    DispatchQueue.main.async {
                        self.registLocalNotification(plan: todayPlan, planData: todayPlanData)
                        
                        self.widgetPlans = [NotiPlan(
                            day: todayPlan.day,
                            book: todayPlan.book,
                            fChap: todayPlan.fChap,
                            fVer: todayPlan.fVer,
                            lChap: todayPlan.lChap,
                            lVer: todayPlan.lVer,
                            verses: todayPlanData.verses)]
                        
                        self.writeNotiPlan()
                        WidgetCenter.shared.reloadTimelines(ofKind: "MealWidget")
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

                DispatchQueue.main.async {
                    self.loading = false
                }
            })
            .store(in: &cancelables)
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
    
    func registLocalNotification(plan: Plan, planData: PlanData) {
        self.manager.addNotification(title: "오늘의 끼니", subtitle: self.getDayMealPlanStr(plan: plan), body: self.getBibleSummary(verses: planData.verses))
        self.manager.schedule()
    }
    
    func getBibleSummary(verses: [String])-> String {
        return verses[0...3].joined(separator: " ")
    }
    
   func getDayMealPlanStr(plan: PlanProtocol) -> String {
        return "\(self.getBookTitle(book: plan.book) ?? plan.book) \(plan.fChap):\(plan.fVer)-\(plan.fChap != plan.lChap ? "\(plan.lChap):" : "" )\(plan.lVer)"
    }
    
    struct MealIconView: View {
        var body: some View
        {
            Image(uiImage: UIImage(named: "riceBowlIcon")!)
                .resizable()
                .renderingMode(.template)
                .frame(width: 40, height: 40)
                .foregroundColor(Color(UIColor.label))
                .padding([.leading, .trailing], 20)
                .unredacted()
        }
    }
}
