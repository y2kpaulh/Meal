//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkReachability: NetworkReachability

    @StateObject var planStore = PlanStore()
    @State private var isPresented = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        if let todayPlan = planStore.todayPlan, let todayPlanData = planStore.todayPlanData {
            ZStack {
                //Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
                
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
                                
                                Text(planStore.convertDateToStr())
                                    .foregroundColor(.gray)
                                
                                Button(action: { isPresented.toggle() }) {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                        .renderingMode(.template)
                                        .accessibilityLabel(Text("끼니 말씀 일정표"))
                                        .foregroundColor(Color(UIColor.label))
                                }
                                .sheet(isPresented: $isPresented,
                                       onDismiss: didDismiss) {
                                    MealPlanList()
                                        .environmentObject(planStore)
                                }
                            }
                            .padding(.top, 10)
                            
                            VStack {
                                HStack() {
                                    Text("\(todayPlanData.book) \(todayPlan.fChap):\(todayPlan.fVer)-\(todayPlan.fChap != todayPlan.lChap ? "\(todayPlan.lChap):" : "" )\(todayPlan.lVer)")
                                        .foregroundColor(Color(UIColor.label))
                                        .font(.custom("NanumMyeongjoOTFBold", size: 20))
                                }
                                Rectangle()
                                    .fill(Color(UIColor.systemBackground))
                                    .frame(height: 0.5)
                            }
                        }
                        
                        Divider()
                            .foregroundColor(Color(UIColor.label))
                            .padding([.leading, .trailing], 20)
                            .padding(.bottom, 10)
                        
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(Array(todayPlanData.verses.enumerated()), id: \.1) { index, verse in
                                    HStack(alignment: .top) {
                                        if todayPlan.fChap == todayPlan.lChap {
                                            Text("\(index + todayPlan.fVer)")
                                                .foregroundColor(.gray)
                                        }
                                        else {
                                            if let planBook = BibleStore.books.filter { $0.abbrev == todayPlan.book }.first {
                                                let verseIndex = index + todayPlan.fVer
                                                
                                                let fChapterCount = planBook.chapters[todayPlan.fChap - 1].count

                                                Text("\(verseIndex > fChapterCount ? verseIndex - fChapterCount : verseIndex)")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Text(verse)
                                            .foregroundColor(.mealTheme)
                                            .font(.custom("NanumMyeongjoOTF", size: 20))
                                            .padding(.top, 4)
                                    }
                                    .padding([.leading, .trailing], 20)
                                    .padding(.bottom, 10)
                                }
                                .redacted(reason: planStore.loading ? .placeholder : [])

                            }
                        }
                        .mask(
                            VStack(spacing: 0) {
                                // top gradient
                                LinearGradient(gradient:
                                   Gradient(
                                    colors: [Color.black.opacity(0), Color.black]),
                                       startPoint: .top, endPoint: .bottom
                                   )
                                .frame(height: 6)

                                // Middle
                                Rectangle().fill(Color.black)

                                // bottom gradient
                                LinearGradient(gradient:
                                   Gradient(
                                       colors: [Color.black, Color.black.opacity(0)]),
                                               startPoint: .top, endPoint: .bottom
                                   )
                                .frame(height: 6)
                            }
                         )
                        
                        Color.clear
                            .frame(width: .infinity, height: 40, alignment: .center)
                    }
                    //.padding(.all, proxy.size.width * 0.05 / 2)
                }
                .padding()
            }
        }
        
        if planStore.loading && (planStore.todayPlanData == nil) && networkReachability.reachable {
            ActivityIndicator()
        }
        
        if planStore.planDataError {
            Text("오늘 날짜의 끼니 말씀을 찾을수 없습니다.")
        }
        
        if !networkReachability.reachable {
            Text("서버 연결 오류가 발생했습니다.\n네트워크 연결 상태를 확인해주세요.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding()
        }
    }
    
    func didDismiss() {
        // Handle the dismissing action.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlanStore())
    }
}
