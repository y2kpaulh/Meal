//
//  MealPlanList.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI
import Combine

struct MealPlanList: View {
  @EnvironmentObject var viewModel: MealPlanViewModel
  @Binding var isPresented: Bool

  var body: some View {
    VStack {
      Text("일정")
        .foregroundColor(Color(UIColor.label))
        .font(.custom("NanumBrushOTF", size: 30))

      ScrollViewReader { scrollView in
        ScrollView {
          LazyVStack {
            ForEach(0..<self.viewModel.planList.count, id: \.self) { index in
              PlanView(index: index, plan: self.viewModel.planList[index])
                .id(index)
                .padding(10)
                .onTapGesture {
                  Swift.print("tap index \(index)")
                  self.viewModel.changePlanIndex(index: index)
                  self.isPresented = false
                }
            }
          }
          .onAppear {
            withAnimation {
              let todayIndex = self.viewModel.planList.firstIndex { $0.day == PlanStore().getDateStr() }
              scrollView.scrollTo(todayIndex, anchor: .top)
            }
          }
        }
      }
      .listVerticalShadow()
    }
    .frame(height: 500)
    .onAppear {
      UITableView.appearance().backgroundColor = .clear
      UITableViewCell.appearance().backgroundColor = .clear
    }
  }

  struct MealPlanList_Previews: PreviewProvider {
    static var previews: some View {
      MealPlanList(isPresented: .constant(false))
        .environmentObject(MealPlanViewModel())
    }
  }
}
