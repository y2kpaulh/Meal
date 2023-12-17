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
  @Environment(\.dismiss) var dismiss
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 10, alignment: .center)

      ZStack {
        HStack {
          Spacer()
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.gray)
          }
          Spacer().frame(width: 20)
        }

      }

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

                  NotificationCenter.default.post(name: .changedDayNotification, object: nil)
                }
            }
          }
          .task {
            withAnimation {
              let todayIndex = self.viewModel.planList.firstIndex { $0.day == PlanStore().getDateStr() }
              scrollView.scrollTo(todayIndex, anchor: .top)
            }
          }
        }
      }
      .listVerticalShadow()
    }
    .frame(height: UIScreen.main.bounds.size.height - 100)
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
