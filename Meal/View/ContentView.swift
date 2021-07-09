//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bibleStore: BibleStore
    var todayPlan: [String: Any]?
    
    init() {
        bibleStore = BibleStore(books: loadJson("bible.json"))
        todayPlan = bibleStore.todayPlan()
           
        if let plan = todayPlan, let verses = plan["verse"] as? [String] {
            print(verses)
        }
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let plan = todayPlan, let verses = plan["verse"] as? [String] {
            VStack {
                Text("끼니")
                    .font(.largeTitle)
                List(verses, id: \.self) { verse in
                      Text(verse)
                }
            }
        }
        else{
            Text("Plain is not exist!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
