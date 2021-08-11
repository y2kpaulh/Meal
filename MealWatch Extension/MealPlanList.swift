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
    ScrollViewReader { _ in
      ScrollView {
        LazyVStack {
          ForEach(Array(viewModel.planList.enumerated()), id: \.1) { index, plan in
            PlanView(index: index, plan: plan)
              .padding([.leading, .trailing], 4)
              .padding([.bottom], -40)
              .onTapGesture {

              }
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
