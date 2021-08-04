//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var planStore: PlanStore
    @State private var isPresented = false

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let todayPlan = planStore.todayPlan, let todayPlanData = planStore.todayPlanData {
            ZStack {
                Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                
                GeometryReader { proxy in
                   RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(UIColor.systemBackground))
                    .shadow(color: .mealTheme, radius: 10)
     
                    VStack(spacing: 0) {
                        VStack() {
                            HStack(alignment: .center) {
                                Text("끼니")
                                    .foregroundColor(Color(UIColor.label))
                                    .font(.custom("NanumBrushOTF", size: 80))
                                Text(planStore.todayDateStr())
                                    .foregroundColor(.gray)
//                                Button("Present!") {
//                                           isPresented.toggle()
//                                       }
//                                       .fullScreenCover(isPresented: $isPresented, content: MealPlanList.init)
                            }
                            .padding(.top, 10)
                            
                            VStack {
                                HStack() {
                                    Text("\(todayPlanData.book) \(todayPlan.sChap):\(todayPlan.sVer)-\(todayPlan.fVer)")
                                        .foregroundColor(Color(UIColor.label))
                                        .fontWeight(.bold)
                                }
                                Rectangle()
                                    .fill(Color(UIColor.systemBackground))
                                    .frame(height: 0.5)
                            }
                        }
                        
                        List {
                            ForEach(Array(todayPlanData.verses.enumerated()), id: \.1) { index, verse in
                                HStack(alignment: .top) {
                                    Text("\(index + todayPlan.sVer)")
                                        .foregroundColor(.gray)
                                        
                                    Text(verse)
                                        .foregroundColor(.mealTheme)
                                    //.font(.custom("NanumPenOTF", size: 24))
                                }
                            }
                        }
                      
                    }
                    .padding(.all, proxy.size.width * 0.05 / 2)
                }
                .padding()
            }
        }
        
        if planStore.planDataError {
            Text("오늘 날짜의 끼니 말씀을 찾을수 없습니다.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}
