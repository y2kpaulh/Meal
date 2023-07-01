//
//  DataModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation

// MARK: - ReadingPlan
//struct ReadingPlan: Codable {
//  let readingPlan: [DailyPlan]
//}
typealias ReadingPlan = [DailyPlan]

// MARK: - DailyPlan
struct DailyPlan: Codable, Identifiable, Hashable {
  static func == (lhs: DailyPlan, rhs: DailyPlan) -> Bool {
    return lhs.id == rhs.id
  }

  public var id: String { day }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  let day: String
  var meal: Scripture
  var readThrough: [Scripture]
}

struct BibleBook: Codable, Identifiable {
  var id: String { abbrev }
  let abbrev, name: String
  let chapters: [[String]]
}

// MARK: - Scripture
struct Scripture: Codable {
  let book: String
  let fChap, fVer, lChap: Int
  var lVer: Int
}

protocol BiblePlanable {
  var day: String { get }
  var plan: [Scripture] { get }
}

protocol Planable {
  var day: String { get }
  var meal: Scripture { get }
  var readThrough: [Scripture] { get }
}

// MARK: - Plan
//public struct Plan: Planable, Codable, Identifiable, Hashable {
//  public var id: String { day }
//  let day: String
//  let book: String
//  //let book: Book
//  let fChap, fVer, lChap, lVer: Int
//}

struct LocalPushPlan: Codable {
  let title: String
  let subTitle: String
  let body: String
  let month: Int
  let day: Int
}

struct NotiPlan: Planable, Codable {
  let day: String
  var meal: Scripture
  var readThrough: [Scripture]
  let verses: [String]
}

public struct Word: Codable {
  let book: String
  let verses: [String]
}

enum Book: String, Codable {
  case 창 = "창"
  case 출 = "출"
  case 레 = "레"
  case 민 = "민"
  case 신 = "신"
  case 수 = "수"
  case 삿 = "삿"
  case 롯 = "롯"
  case 삼상 = "삼상"
  case 삼하 = "삼하"
  case 왕상 = "왕상"
  case 왕하 = "왕하"
  case 대상 = "대상"
  case 대하 = "대하"
  case 스 = "스"
  case 느 = "느"
  case 에 = "에"
  case 욥 = "욥"
  case 시 = "시"
  case 잠 = "잠"
  case 전 = "전"
  case 아 = "아"
  case 사 = "사"
  case 렘 = "렘"
  case 애 = "애"
  case 겔 = "겔"
  case 단 = "단"
  case 호 = "호"
  case 욜 = "욜"
  case 암 = "암"
  case 옵 = "옵"
  case 욘 = "욘"
  case 미 = "미"
  case 나 = "나"
  case 합 = "합"
  case 습 = "습"
  case 학 = "학"
  case 슥 = "슥"
  case 말 = "말"
  case 마 = "마"
  case 막 = "막"
  case 눅 = "눅"
  case 요 = "요"
  case 행 = "행"
  case 롬 = "롬"
  case 고전 = "고전"
  case 고후 = "고후"
  case 갈 = "갈"
  case 엡 = "엡"
  case 빌 = "빌"
  case 골 = "골"
  case 살전 = "살전"
  case 살후 = "살후"
  case 딤전 = "딤전"
  case 딤후 = "딤후"
  case 딛 = "딛"
  case 몬 = "몬"
  case 히 = "히"
  case 약 = "약"
  case 벧전 = "벧전"
  case 벧후 = "벧후"
  case 요일 = "요일"
  case 요이 = "요이"
  case 요삼 = "요삼"
  case 유 = "유"
  case 계 = "계"
}
