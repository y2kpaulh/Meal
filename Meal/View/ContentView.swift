//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bibleStore: BibleStore
    @ObservedObject var planStore: PlanStore

    init() {
        bibleStore = BibleStore(books: loadJson("bible.json"))
        planStore = PlanStore(plan: loadJson("plan.json"))
        
        print( planStore.plan[0])

        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
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
                List {
                    ForEach(bibleStore.books) { book in
                        Section(header: Text(book.abbrev)) {
                            Text("\(book.chapters[0][0])")
                                .font(.headline)
                        }
                    }
                    .listRowBackground(Color.yellow)
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
