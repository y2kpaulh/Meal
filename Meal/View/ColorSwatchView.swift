//
//  ColorSwatchView.swift
//
//  Created by Andrew Jackson on 22/08/2020.
//

import SwiftUI

struct ColorSwatchView: View {
  var colorCircleSize: CGFloat = 30

  @Binding var selection: String

  var body: some View {

    let swatches = [
      "swatch_chestnutrose",

      "swatch_wisteria",
      "swatch_mulberry",
      "swatch_charm"
    ]

    let columns = [
      GridItem(.adaptive(minimum: colorCircleSize))
    ]

    LazyVGrid(columns: columns, spacing: 10) {
      ForEach(swatches, id: \.self) { swatch in
        ZStack {
          Circle()
            .fill(Color(swatch))
            .frame(width: colorCircleSize-10, height: colorCircleSize-10)
            .onTapGesture(perform: {
              selection = swatch
            })
            .padding(10)

          if selection == swatch {
            Circle()
              .stroke(Color(swatch), lineWidth: 5)
              .frame(width: colorCircleSize, height: colorCircleSize)
          }
        }
      }
    }
    .padding(10)
  }
}

struct ColorSwatchView_Previews: PreviewProvider {
  static var previews: some View {
    ColorSwatchView(selection: .constant("swatch_shipcove"))
  }
}
