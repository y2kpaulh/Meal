//
//  WatchHeaderView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

struct WatchHeaderView: View {
  @Binding var todayPlan: Plan

  var body: some View {
    VStack {
      HStack(alignment: .center) {
        MealTitleLabel(size: 34, textColor: Color.white)

        Text(PlanStore().convertDateToStr())
          .foregroundColor(.gray)
      }

      Text(PlanStore().getMealPlanStr(todayPlan))
        .font(.custom("NanumMyeongjoOTFBold", size: 16))
    }
  }
}

struct WatchHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    WatchHeaderView(todayPlan: .constant(Plan(day: "", book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)))
  }
}
