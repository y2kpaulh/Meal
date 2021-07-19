//
//  MealPlanList.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct MealPlanList: View {
    @EnvironmentObject var planStore: PlanStore
    @Environment(\.presentationMode) var presentationMode

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
            ZStack {
                Color.gray.edgesIgnoringSafeArea(.all)

                GeometryReader { proxy in
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(radius: 10)
                    
                    VStack(spacing: 10) {
                        Button("Dismiss Modal") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        VStack() {
                            List {
                                ForEach(planStore.planList) {
                                    Text("\($0.day) \($0.book) \($0.sChap):\($0.sVer)-\($0.fChap): \($0.fVer)")
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
    }
    
    struct MealPlanList_Previews: PreviewProvider {
        static var previews: some View {
            MealPlanList()
        }
    }
}
