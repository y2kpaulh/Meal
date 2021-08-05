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
            ZStack(alignment: .center) {
                Text("끼니 일정표")
                    .font(.custom("NanumBrushOTF", size: 40))
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top, 20)
                
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
                LazyVStack{
                    ForEach(Array(planStore.planList.enumerated()),id: \.1) { index, plan in
                        PlanView(index: index, plan: plan)
                            .environmentObject(planStore)
                            .padding(10)
                            .onTapGesture {
    
                            }
                    }
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
        }
    }
    
    struct MealPlanList_Previews: PreviewProvider {
        static var previews: some View {
            MealPlanList()
                .environmentObject(PlanStore())
        }
    }
}
