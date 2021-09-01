//
//  TestView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/09/01.
//

import SwiftUI

struct TestView: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
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

    Spacer()
  }
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestView()
  }
}
