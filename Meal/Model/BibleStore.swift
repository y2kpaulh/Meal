//
//  Bible.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation

class BibleStore: ObservableObject {
    @Published var books: [BibleBook] = []
    @Published var subjects: [String] = []
    
    init (books: [BibleBook] = []) {
        self.books = books
        self.subjects = loadJson("biblebook-ko.json")
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
    
    func todayPlan() -> [String:Any]? {
        let planStore = PlanStore(plan: loadJson("plan.json"))
        guard let plan = planStore.todayPlan() else { return nil }

        let book = self.books.filter { $0.abbrev == plan.book }
        
        guard book.count > 0, let planBook = book.first, let index = self.books.firstIndex(where: { $0.abbrev == plan.book })  else { return nil}
        
        let subject = self.subjects[index]
        let chapter = planBook.chapters[plan.sChap-1]
        let verseRange = chapter[plan.sVer+1..<plan.fVer+1]
        let verse = Array(verseRange)
        
        return ["subject": subject, "detail": plan, "verse": verse]
    }
}
