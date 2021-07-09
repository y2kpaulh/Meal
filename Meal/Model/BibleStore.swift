//
//  Bible.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation

class BibleStore: ObservableObject {
    @Published var books: [BibleBook] = []
    
    init (books: [BibleBook] = []) {
        self.books = books
    }
}

extension BibleStore {
    func load() -> [BibleBook] {
      var cards: [BibleBook] = []
      guard let path = FileManager.documentURL?.path,
        let enumerator =
          FileManager.default.enumerator(atPath: path),
            let files = enumerator.allObjects as? [String]
      else { return cards }
      let cardFiles = files.filter { $0.contains(".json") }
      for cardFile in cardFiles {
        do {
          let path = path + "/" + cardFile
          let data =
            try Data(contentsOf: URL(fileURLWithPath: path))
          let decoder = JSONDecoder()
          let card = try decoder.decode(BibleBook.self, from: data)
          cards.append(card)
        } catch {
          print("Error: ", error.localizedDescription)
        }
      }
      return cards
    }
}
