//
//  MealPlanList.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

struct MealPlanList: View {
  @EnvironmentObject var viewModel: MealPlanViewModel

  var body: some View {
    ScrollViewReader { scrollView in
      ScrollView {
        LazyVStack {
          ForEach(0..<viewModel.readingPlan.count, id: \.self) { index in
            PlanView(index: index, plan: viewModel.readingPlan[index])
              .id(index)
              .padding([.leading, .trailing], 4)
              .padding([.bottom], -40)
              .onTapGesture {

              }
          }
        }
        .onAppear {
          withAnimation {
            let todayIndex = viewModel.readingPlan.firstIndex { $0.day == PlanStore().getDateStr() }
            scrollView.scrollTo(todayIndex, anchor: .top)
          }
        }
      }
    }
    .listVerticalShadow()
  }

  //  struct MealPlanList_Previews: PreviewProvider {
  //    static var previews: some View {
  //      MealPlanList
  //        .environmentObject(MealPlanViewModel())
  //    }
  //  }
}
