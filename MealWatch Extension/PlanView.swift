//
//  PlanView.swift
//  MealWatch Extension
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

struct PlanView: View {
  let index: Int
  let plan: DailyReading

  var body: some View {
    VStack(alignment: .leading, spacing: -4) {
      HStack(alignment: .center, spacing: -4) {

        VStack(alignment: .leading, spacing: -6) {
          HStack {
            MealTitleLabel(size: 40,
                           textColor: .white)

            Text("\(PlanStore().convertDateToStr(date: PlanStore().dateFormatter.date(from: plan.day)!))")
              .font(.footnote)
              .foregroundColor(Color(.gray))
              .bold()
          }

          Text(PlanStore().getMealPlanStr(plan.meal))
            .foregroundColor(.white)
            .font(.custom("NanumMyeongjoOTFBold", size: 16))
            .bold()

        }
        .padding(.horizontal)
        .foregroundColor(Color.gray)
      }

      Text(PlanStore().getBibleSummary(verses: PlanStore().getMealWord(plan.meal).verses))
        .font(.custom("NanumMyeongjoOTF", size: 14))
        .lineLimit(3)
        .lineSpacing(6.0)
        .font(.footnote)
        .foregroundColor(.white)
        .padding([.top, .bottom], 20)
        .padding([.leading, .trailing], 4)

    }
    .padding(10)
  }
}

//struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView(index: 0, plan: Plan())
//            .previewLayout(.sizeThatFits)
//            .colorScheme(.dark)
//    }
//}
