//
//  MealTitleLabelView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI

struct MealTitleLabelView: View {
  var size: CGFloat

  var body: some View {
    Text("끼니")
      .foregroundColor(.white)
      .font(.custom("NanumBrushOTF", size: size))
  }
}

struct MealTitleLabelView_Previews: PreviewProvider {
  static var previews: some View {
    MealTitleLabelView(size: 40)
  }
}
