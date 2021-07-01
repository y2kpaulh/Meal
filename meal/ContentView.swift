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
        ScrollView{
            VStack {
                Text("오늘의 끼니")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
                    Text(bibleStore.books[0].abbrev)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(Date())")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                }
                .padding()
                
                Text("\(bibleStore.books[0].chapters[0][0])")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
