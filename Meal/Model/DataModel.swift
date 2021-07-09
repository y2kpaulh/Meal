//
//  DataModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation

struct BibleBook: Codable, Identifiable {
    var id: String { abbrev }
    let abbrev: String
    let chapters: [[String]]
    let name: String
}

struct mealPlan: Codable, Identifiable {
    var id: String { day }
    var day: String
    var book: String
    var sChapter: String
    var sVerse: String
    var fChapter: String
    var fVerse: String
}
