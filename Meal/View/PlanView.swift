//
//  PlanView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/05.
//

import SwiftUI

struct PlanView: View {
    let index: Int
    let plan: Plan
    
    @EnvironmentObject var planStore: PlanStore
   
    @Environment(\.verticalSizeClass) var
        verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var
        horizontalSizeClass: UserInterfaceSizeClass?
    var isIPad: Bool {
        horizontalSizeClass == .regular &&
            verticalSizeClass == .regular
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: -4) {
            HStack(alignment: .center, spacing: -4) {
                Image(uiImage: UIImage(named: "riceBowlIcon")!)
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor.label))
                    .padding([.leading, .trailing], 10)
                
//                MealButtonIcon(width: 40, height: 40, radius: 6)
//                    .padding([.leading], 10)
                
                VStack(alignment: .leading, spacing: -6) {
                    HStack{
                        Text("끼니")
                            .font(.custom("NanumBrushOTF", size: 40))
                            .foregroundColor(Color(UIColor.label))
                            .bold()
                        
                        Text("\(planStore.convertDateToStr(date: planStore.dateFormatter.date(from: plan.day)!))")
                            .font(.footnote)
                            .foregroundColor(Color(.gray))
                            .bold()
                    }
                                        
                    Text(planStore.getDayMealPlanStr(plan: plan))
                        .foregroundColor(Color(UIColor.label))
                        .font(.custom("NanumMyeongjoOTFBold", size: 16))
                        //.bold()
                }
                .padding(.horizontal)
                .foregroundColor(Color(UIColor.systemGray))
            }
            
            if let planData = planStore.getDayPlanData(plan: plan) {
                Text(planStore.getBibleSummary(verses: planData.verses))
                    .font(.custom("NanumMyeongjoOTF", size: 12))
                    .lineLimit(3)
                    //.font(.footnote)
                    .foregroundColor(Color(UIColor.label))
                    .padding([.top,.bottom], 20)
                    .padding([.leading,.trailing], 10)
            }          
        }
        .padding(10)
        .frame(width: isIPad ? 644 : nil)
        .background(Color.itemBkgd)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

//struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView(index: 0, plan: Plan())
//            .previewLayout(.sizeThatFits)
//            .colorScheme(.dark)
//    }
//}
