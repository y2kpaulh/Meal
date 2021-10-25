//
//  Bible.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation
import Combine

struct BibleStore {
  static let books: [BibleBook] = load("RNKSV.json") //load("NKRV.json")
  static let titles: [String] = load("biblebook-ko.json")
}
