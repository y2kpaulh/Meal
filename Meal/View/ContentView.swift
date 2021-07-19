//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var planStore: PlanStore
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let todayPlan = planStore.todayPlan, let planData = planStore.getTodayPlanData() {
            
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)
                
                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 10)
     
                    VStack(spacing: 10) {
                        VStack() {
                            HStack(alignment: .center) {
                                Text("끼니")
                                    .foregroundColor(.black)
                                    .font(.custom("NanumBrushOTF", size: 80))
                                Text(planStore.todayDateStr())
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 10)
                            
                            VStack {
                                HStack() {
                                    Text("\(planData.book) \(todayPlan.sChap):\(todayPlan.sVer)-\(todayPlan.fVer)")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(height: 0.5)
                            }
                        }
                        
                        List {
                            ForEach(Array(planData.verses.enumerated()), id: \.1) { index, verse in
                                HStack(alignment: .top) {
                                    Text("\(index + todayPlan.sVer)")
                                        .foregroundColor(.gray)
                                        
                                    Text(verse)
                                        .foregroundColor(.black)
                                    //.font(.custom("NanumPenOTF", size: 24))
                                }
                            }
                            .listRowBackground(Color.white)
                        }
                         .padding(.bottom, proxy.size.width * 0.2 / 2)
                    }
                    .background(Color.white)
                    .frame(width: proxy.size.width * 0.95,height: proxy.size.height * 0.95)
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
    }
}
