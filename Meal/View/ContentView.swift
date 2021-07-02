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
        ZStack{
            //background color
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("오늘의 끼니")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack(alignment: .center, spacing: 20) {
                    Text(bibleStore.books[0].abbrev)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(Date().description)")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                }
                
                //MainView
                ScrollView {
                    ForEach(bibleStore.books, id: \.id) { book in
                        Text(book.abbrev)
                        Text("\(book.chapters[0][0])")
                            .font(.title)
                            .padding()
                        }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
