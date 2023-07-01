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

  var readingPlan: ReadingPlan {
    if let readingPlan = try? readReadingPlanFile(fileName: "readingPlan"),
       readingPlan.filter({ $0.day == PlanStore().getDateStr() }).count > 0 {
      return readingPlan
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

  func getMealWord(_ scripture: Scripture) -> Word {
    let book = BibleStore.books.filter { $0.abbrev == scripture.book }

    guard book.count > 0,
          let planBook = book.first,
          let index = BibleStore.books.firstIndex(where: { $0.abbrev == scripture.book })
    else { return Word(book: "", verses: []) }

    let title = BibleStore.titles[index]
    var verse = [String]()

    if scripture.fChap == scripture.lChap {
      let chapter = planBook.chapters[scripture.fChap-1]
      let verseRange = chapter[scripture.fVer-1..<scripture.lVer]

      verse = Array(verseRange)
    } else {
      let fChapter = planBook.chapters[scripture.fChap-1]
      let lChapter = planBook.chapters[scripture.lChap-1]

      let fVerseRange = fChapter[scripture.fVer-1..<fChapter.count]
      let lVerseRange = lChapter[0..<scripture.lVer]

      verse = Array(fVerseRange + lVerseRange)
    }

    return Word(book: title, verses: verse)
  }

  func getReadThroughWord(_ scripture: [Scripture]) -> (planList: [Word], lVerArr: [Int]) {
    var biblePlanList = [Word]()
    var lVerArr = [Int]()

    biblePlanList = scripture.enumerated().map { (index, element) in
      let book = BibleStore.books.filter { $0.abbrev == element.book }

      guard book.count > 0,
            let planBook = book.first,
            let index = BibleStore.books.firstIndex(where: { $0.abbrev == element.book })
      else { return Word(book: "", verses: []) }

      let title = BibleStore.titles[index]
      var verse = [String]()

      if element.fChap == element.lChap {
        let chapter = planBook.chapters[element.fChap-1]

        //임의로 마지막 인덱스를 100으로 설정
        var lVer: Int = 0
        if element.lVer == 100 {
          lVer = chapter.count
        } else {
          lVer = element.lVer
        }

        lVerArr.append(lVer)

        let verseRange = chapter[element.fVer-1..<lVer]

        verse = Array(verseRange)
      } else {
        let fChapter = planBook.chapters[element.fChap-1]
        let lChapter = planBook.chapters[element.lChap-1]

        let fVerseRange = fChapter[element.fVer-1..<fChapter.count]

        //임의로 마지막 인덱스를 100으로 설정
        var lVer: Int = 0

        if element.lVer == 100 {
          lVer = lChapter.count
        } else {
          lVer = element.lVer
        }

        lVerArr.append(lVer)

        let lVerseRange = lChapter[0..<lVer]

        verse = Array(fVerseRange + lVerseRange)
      }
      return Word(book: title, verses: verse)
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

  func getMealPlanStr(_ plan: Scripture) -> String {
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

    PlanStore.dailyPushList = PlanStore().readingPlan
      .map { plan in
        let targetDay = plan.day.split(separator: "-")

        return LocalPushPlan(title: "오늘의 끼니",
                             subTitle: PlanStore().getMealPlanStr(plan.meal),
                             body: PlanStore().getBibleSummary(verses: PlanStore().getMealWord(plan.meal).verses), month: Int(targetDay[1]) ?? 0, day: Int(targetDay[2]) ?? 0)
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
      [
        {
          "day": "2023-07-01",
          "meal": {
            "book": "시",
            "fChap": 103,
            "fVer": 15,
            "lChap": 103,
            "lVer": 22
          },
          "readThrough": [
            {
              "book": "사",
              "fChap": 21,
              "fVer": 1,
              "lChap": 24,
              "lVer": 100
            }
          ]
        },
        {
          "day": "2023-07-02",
          "meal": {
            "book": "시",
            "fChap": 104,
            "fVer": 1,
            "lChap": 104,
            "lVer": 18
          },
          "readThrough": [
            {
              "book": "사",
              "fChap": 25,
              "fVer": 1,
              "lChap": 29,
              "lVer": 100
            }
          ]
        },
        {
          "day": "2023-07-03",
          "meal": {
            "book": "시",
            "fChap": 104,
            "fVer": 19,
            "lChap": 104,
            "lVer": 35
          },
          "readThrough": [
            {
              "book": "사",
              "fChap": 30,
              "fVer": 1,
              "lChap": 35,
              "lVer": 100
            }
          ]
        },
        {
          "day": "2023-07-04",
          "meal": {
            "book": "시",
            "fChap": 105,
            "fVer": 1,
            "lChap": 105,
            "lVer": 11
          },
          "readThrough": [
            {
              "book": "왕하",
              "fChap": 18,
              "fVer": 13,
              "lChap": 18,
              "lVer": 37
            },
            {
              "book": "사",
              "fChap": 36,
              "fVer": 1,
              "lChap": 37,
              "lVer": 100
            }
          ]
        },
        {
          "day": "2023-07-05",
          "meal": {
            "book": "시",
            "fChap": 105,
            "fVer": 12,
            "lChap": 105,
            "lVer": 23
          },
          "readThrough": [
            {
              "book": "왕하",
              "fChap": 19,
              "fVer": 1,
              "lChap": 19,
              "lVer": 100
            },
            {
              "book": "사",
              "fChap": 37,
              "fVer": 1,
              "lChap": 37,
              "lVer": 100
            }
          ]
        },
        {
          "day": "2023-07-06",
          "meal": {
            "book": "시",
            "fChap": 105,
            "fVer": 24,
            "lChap": 105,
            "lVer": 45
          },
          "readThrough": [
            {
              "book": "왕하",
              "fChap": 19,
              "fVer": 1,
              "lChap": 19,
              "lVer": 100
            },
            {
              "book": "사",
              "fChap": 37,
              "fVer": 1,
              "lChap": 37,
              "lVer": 100
            }
          ]
        }
      ]
      """.utf8)
  }
}
