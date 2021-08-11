//
//  ListVerticalShadow.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

//https://www.hackingwithswift.com/books/ios-swiftui/custom-modifiers

struct ListVerticalShadow: ViewModifier {
  func body(content: Content) -> some View {
    content
      .mask(
        VStack(spacing: 0) {
          // top gradient
          LinearGradient(gradient:
                          Gradient(
                            colors: [Color.black.opacity(0), Color.black]),
                         startPoint: .top, endPoint: .bottom
          )
          .frame(height: 6)

          // Middle
          Rectangle().fill(Color.black)

          // bottom gradient
          LinearGradient(gradient:
                          Gradient(
                            colors: [Color.black, Color.black.opacity(0)]),
                         startPoint: .top, endPoint: .bottom
          )
          .frame(height: 6)
        }
      )
  }
}

extension View {
  func listVerticalShadow() -> some View {
    self.modifier(ListVerticalShadow())
  }
}
