//
//  MealTitleLabel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI
import UIKit

struct MealTitleLabel: View {
  var size: CGFloat
  var textColor: Color

  var body: some View {
    //    Text("끼니")
    //      .foregroundColor(textColor)
    //      .font(.custom("NanumBrushOTF", size: size))
    Image(uiImage: UIImage(named: "meal")!)
      .resizable()
      .renderingMode(.template)
      .foregroundColor(textColor)
      .frame(width: 60, height: 80)
  }
}

struct MealTitleLabel_Previews: PreviewProvider {
  static var previews: some View {
    MealTitleLabel(size: 40, textColor: .white)
  }
}
