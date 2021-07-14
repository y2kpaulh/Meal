//
//  DataModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation

struct BibleBook: Codable, Identifiable {
    var id: String { abbrev }
    let abbrev, name : String
    let chapters: [[String]]
}

struct MealPlan: Codable, Identifiable {
    var id: String { day }
    var day: String
    var book: String
    var sChap: Int
    var sVer: Int
    var fChap: Int
    var fVer: Int
}
