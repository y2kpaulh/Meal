//
//  PlanStore.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation
import Combine
#if !os(watchOS)
import WidgetKit
#endif
import SwiftUI
import UIKit

public final class PlanStore: ObservableObject {
  let localNotiManager = LocalNotificationManager()

  var mealPlan: [MealPlan] {
    if let mealPlan = try? readMealPlanFile(fileName: "mealPlan"),
       mealPlan.filter({ $0.day == PlanStore().getDateStr() }).count > 0 {
      return mealPlan
    } else {
      return []
    }
  }

  var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko") // 로케일 변경

    return dateFormatter
  }

  func getPlanData(_ plan: MealPlan) -> BibleText {
    let book = BibleStore.books.filter { $0.abbrev == plan.book }

    guard book.count > 0,
          let planBook = book.first,
          let index = BibleStore.books.firstIndex(where: { $0.abbrev == plan.book })
    else { return BibleText(book: "", verses: []) }

    let title = BibleStore.titles[index]
    var verse = [String]()

    if plan.fChap == plan.lChap {
      let chapter = planBook.chapters[plan.fChap-1]
      let verseRange = chapter[plan.fVer-1..<plan.lVer]

      verse = Array(verseRange)
    } else {
      let fChapter = planBook.chapters[plan.fChap-1]
      let lChapter = planBook.chapters[plan.lChap-1]

      let fVerseRange = fChapter[plan.fVer-1..<fChapter.count]
      let lVerseRange = lChapter[0..<plan.lVer]

      verse = Array(fVerseRange + lVerseRange)
    }

    return BibleText(book: title, verses: verse)
  }

  func getReadThroughVerses(_ biblePlan: [BibleVerse]) -> (planList: [BibleText], lVerArr: [Int]) {
    var biblePlanList = [BibleText]()
    var lVerArr = [Int]()

    biblePlanList = biblePlan.enumerated().map { (index, element) in
      let book = BibleStore.books.filter { $0.abbrev == element.book }

      guard book.count > 0,
            let planBook = book.first,
            let index = BibleStore.books.firstIndex(where: { $0.abbrev == element.book })
      else { return BibleText(book: "", verses: []) }

      let title = BibleStore.titles[index]
      var verse = [String]()

      if element.fChap == element.lChap {
        let chapter = planBook.chapters[element.fChap-1]

        //임의로 마지막 인덱스를 100으로 설정
        var lVer: Int = 0
        if element.lVer == 100 {
          lVer = chapter.count - 1
        } else {
          lVer = element.lVer
        }

        lVerArr.append(lVer+1)

        let verseRange = chapter[element.fVer-1..<lVer]

        verse = Array(verseRange)
      } else {
        let fChapter = planBook.chapters[element.fChap-1]
        let lChapter = planBook.chapters[element.lChap-1]

        let fVerseRange = fChapter[element.fVer-1..<fChapter.count]

        //임의로 마지막 인덱스를 100으로 설정
        var lVer: Int = 0

        if element.lVer == 100 {
          lVer = lChapter.count - 1
        } else {
          lVer = element.lVer
        }

        lVerArr.append(lVer+1)

        let lVerseRange = lChapter[0..<lVer]

        verse = Array(fVerseRange + lVerseRange)
      }
      return BibleText(book: title, verses: verse)
    }

    return (planList: biblePlanList, lVerArr: lVerArr)
  }

}

extension PlanStore {
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

  func getBibleSummary(verses: [String]) -> String {
    return verses[0...2].joined(separator: " ")
  }

  func getMealPlanStr(_ plan: Planable) -> String {
    return "\(self.getBookTitle(book: plan.book) ?? plan.book) \(plan.fChap > 0 ? "\(plan.fChap):" : "")\(plan.fVer > 0 ? "\(plan.fVer)-" : "")\(plan.fChap != plan.lChap ? "\(plan.lChap > 0 ? "\(plan.lChap)" : ""):" : "" )\(plan.lVer > 0 ? "\(plan.lVer)" : "")"
  }

  static var dailyPushList: [LocalPushPlan] {
    get {
      var notiPlans: [LocalPushPlan]?
      if let data = UserDefaults.standard.value(forKey: "notiPlans") as? Data {
        notiPlans = try? PropertyListDecoder().decode([LocalPushPlan].self, from: data)
      }
      return notiPlans ?? []
    }
    set {
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "notiPlans")
    }
  }

  func clearDailyPush() {
    self.localNotiManager.removeSchedule()
    PlanStore.dailyPushList = []
  }

  func registDailyPush() {
    clearDailyPush()

    PlanStore.dailyPushList = PlanStore().mealPlan
      .map { plan in
        let targetDay = plan.day.split(separator: "-")

        return LocalPushPlan(title: "오늘의 끼니",
                             subTitle: PlanStore().getMealPlanStr(plan),
                             body: PlanStore().getBibleSummary(verses: PlanStore().getPlanData(plan).verses), month: Int(targetDay[1]) ?? 0, day: Int(targetDay[2]) ?? 0)
      }

    for plan in PlanStore.dailyPushList {
      self.localNotiManager.addNotification(title: plan.title,
                                            subtitle: plan.subTitle,
                                            body: plan.body,
                                            month: plan.month,
                                            day: plan.day)
    }

    self.localNotiManager.schedule()
  }

  var testPlan: Data {
    return Data(
      """
                       {
                       "scheduleList":
                           [
                               {
                                   "day": "2023-06-11",
                                   "meal": {
                                       "book": "왕하",
                                       "fChap": 23,
                                       "fVer": 1,
                                       "lChap": 23,
                                       "lVer": 20
                                   },
                                   "readThrough": [
                                       {
                                       "book": "왕상",
                                       "fChap": 18,
                                       "fVer": 1,
                                       "lChap": 19,
                                       "lVer": 100
                                     },
                                     {
                                       "book": "시",
                                       "fChap": 23,
                                       "fVer": 1,
                                       "lChap": 23,
                                       "lVer": 100
                                    }
                                 ]
                               }
                           ]
                       }
      """.utf8)
  }
}
