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
                
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let plan = todayPlan,  let detail = plan["detail"] as? MealPlan, let verses = plan["verse"] as? [String] {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 10)
     
                    VStack(spacing: 10) {
                        VStack() {
                            HStack(alignment: .center) {
                                Text("끼니")
                                    .foregroundColor(.black)
                                    .font(.custom("NanumBrushOTF", size: 80))
                                Text(bibleStore.todayDateStr())
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 10)
                            
                            HStack() {
                                Text("\(plan["subject"] as! String)")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                                Text("\(detail.sChap) : \(detail.sVer) - \(detail.fVer)")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                
                               // Spacer()
                            }
                        }
                        
                        List {
                            ForEach(Array(verses.enumerated()), id: \.1) { index, verse in
                                HStack(alignment: .top) {
                                    Text("\(index + detail.sVer)")
                                        .foregroundColor(.gray)
                                        
                                    Text(verse)
                                        .foregroundColor(.black)
                                        .font(.custom("NanumBrushOTF", size: 24))
                                }
                            }
                            .listRowBackground(Color.white)
                        }
                         .padding(.bottom, proxy.size.width * 0.2 / 2)
                    }
                    .background(Color.white)
                    .frame(width: proxy.size.width * 0.9)
                    .padding(.leading, proxy.size.width * 0.1 / 2)
                }
                .padding()

//                Text("개역한글 성경")
//                    .foregroundColor(Color.red)
//                    .padding(.bottom)
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
            .preferredColorScheme(.dark)
    }
}
