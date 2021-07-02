//
//  Bible.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation

struct BibleBook: Codable, Identifiable {
    var id: String { abbrev }
    let abbrev: String
    let chapters: [[String]]
    let name: String
}

class BibleStore: ObservableObject {
    @Published var books: [BibleBook]
    
    init (books: [BibleBook] = []) {
        self.books = books

    }
}
