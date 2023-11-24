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
        MealIconView()

        VStack(alignment: .leading, spacing: -6) {
          HStack {
            MealTitleLabel(size: 40,
                           textColor: Color(UIColor.label))

            Text("\(PlanStore().convertDateToStr(date: PlanStore().dateFormatter.date(from: plan.day)!))")
              .font(.footnote)
              .foregroundStyle(Color(.gray))
              .bold()
          }

          Text(PlanStore().getMealPlanStr(plan))
            .foregroundStyle(Color(UIColor.label))
            .font(.custom("NanumMyeongjoOTFBold", size: 16))
          //.bold()
        }
        .padding(.horizontal)
        .foregroundStyle(Color(UIColor.systemGray))
      }

      Text(PlanStore().getBibleSummary(verses: PlanStore().getPlanData(plan).verses))
        .font(.custom("NanumMyeongjoOTF", size: 12))
        .lineLimit(3)
        //.font(.footnote)
        .foregroundStyle(Color(UIColor.label))
        .padding([.top, .bottom], 20)
        .padding([.leading, .trailing], 10)
    }
    .padding(10)
    .frame(width: isIPad ? 644 : nil)
    .background(Color.itemBkgd)
    .cornerRadius(15)
    .shadow(color: Color.black.opacity(0.1), radius: 10)
  }
}

struct PlanView_Previews: PreviewProvider {
  static var previews: some View {
    PlanView(index: 0, plan: Plan(day: "2023-11-19", book: "창", fChap: 1, fVer: 1, lChap: 1, lVer: 3))
      .previewLayout(.sizeThatFits)
      .colorScheme(.dark)
  }
}
