//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bibleStore: BibleStore

    init() {
        let books: [BibleBook] = loadJson("bible.json")
        bibleStore = BibleStore(books: books)
    }
    
    var body: some View {
        Text("\(bibleStore.books[0].chapters[0].description)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
