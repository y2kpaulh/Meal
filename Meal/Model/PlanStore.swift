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

public final class PlanStore: ObservableObject {
//    let manager = LocalNotificationManager()
    
    var dateFormatter: DateFormatter{
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko") // 로케일 변경
        
        return dateFormatter
    }
    
    var widgetPlans: [NotiPlan] = []
    
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
    
    func getPlanData(plan: Plan) -> PlanData {
        let book = BibleStore.books.filter { $0.abbrev == plan.book }
        
        guard book.count > 0,
              let planBook = book.first,
              let index = BibleStore.books.firstIndex(where: { $0.abbrev == plan.book })
        else { return PlanData(book: "", verses: []) }
        
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
    func getDateStr(date: Date = Date()) -> String {
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
    
//    func registLocalNotification(plan: Plan, planData: PlanData) {
//        self.manager.addNotification(title: "오늘의 끼니", subtitle: self.getMealPlanStr(plan: plan), body: self.getBibleSummary(verses: planData.verses))
//        self.manager.schedule()
//    }
    
    func getBibleSummary(verses: [String])-> String {
        return verses[0...3].joined(separator: " ")
    }
    
    func getMealPlanStr(plan: Planable) -> String {
        return "\(self.getBookTitle(book: plan.book) ?? plan.book) \(plan.fChap > 0 ? "\(plan.fChap):" : "")\(plan.fVer > 0 ? "\(plan.fVer)-" : "")\(plan.fChap != plan.lChap ? "\(plan.lChap > 0 ? "\(plan.lChap)" : ""):" : "" )\(plan.lVer > 0 ? "\(plan.lVer)" : "")"
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
