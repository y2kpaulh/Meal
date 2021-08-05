//
//  MealPlanList.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct MealPlanList: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var planStore: PlanStore
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack() {
            ZStack {
                Text("끼니 일정표")
                    .font(.custom("NanumBrushOTF", size: 40))
                    .foregroundColor(Color(UIColor.label))
                    .padding(.all, 20)
                
                HStack() {
                    Spacer()
                    Button(
                        action: {
                            //store.fetchContents()
                            presentationMode.wrappedValue.dismiss()
                            // swiftlint:disable:next multiple_closures_with_trailing_closure
                        }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(Color(UIColor.label))
                            .padding()
                            .background(
                                Circle().fill((Color.closeBkgd))
                            )
                    }
                    .padding([.top, .trailing])
                }
            }
            
            ScrollView {
                ForEach(planStore.planList) {
                    Text("\($0.day) \($0.book) \($0.sChap):\($0.sVer)-\($0.fChap): \($0.fVer)")
                        .font(.custom("NanumBrushOTF", size: 20))
                        .foregroundColor(Color(UIColor.label))
                        .padding([.leading, .trailing], 20)
                        .padding(.bottom, 10)
                }
            }
        }
    }
    
    struct MealPlanList_Previews: PreviewProvider {
        static var previews: some View {
            MealPlanList()
        }
    }
}
