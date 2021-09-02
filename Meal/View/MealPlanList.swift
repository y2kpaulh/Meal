//
//  MealPlanList.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct MealPlanList: View {
  @Binding var planList: [Plan]
  @Environment(\.presentationMode) var presentationMode
  @State private var isPresented = false

  //    init() {
  //        UITableView.appearance().backgroundColor = .clear
  //        UITableViewCell.appearance().backgroundColor = .clear
  //    }

  var body: some View {

    VStack {
      ZStack(alignment: .center) {
        Text("끼니 일정표")
          .font(.custom("NanumBrushOTF", size: 40))
          .foregroundColor(Color(UIColor.label))
          .padding(.top, 20)

        HStack {
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
      ScrollViewReader { scrollView in
        ScrollView {
          LazyVStack {
            ForEach(0..<self.planList.count, id: \.self) { index in
              PlanView(index: index, plan: self.planList[index])
                .id(index)
                //.environmentObject(planStore)
                .padding(10)
            }
          }
          .onAppear {
            withAnimation {
              let todayIndex = self.planList.firstIndex { $0.day == PlanStore().getDateStr() }
              scrollView.scrollTo(todayIndex, anchor: .top)
            }
          }
        }
      }
      .listVerticalShadow()
    }
    .onAppear {
      UITableView.appearance().backgroundColor = .clear
      UITableViewCell.appearance().backgroundColor = .clear
    }
  }

  struct MealPlanList_Previews: PreviewProvider {
    static var previews: some View {
      MealPlanList(planList: .constant([Plan]()))
        .environmentObject(PlanStore())
    }
  }
}
