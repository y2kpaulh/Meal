//
//  MealIconView.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import SwiftUI
import UIKit
import Foundation

struct MealIconView: View {
  var body: some View {
    Image(uiImage: UIImage(named: "riceBowlIcon")!)
      .resizable()
      .renderingMode(.template)
      .frame(width: 40, height: 40)
      .foregroundColor(Color(UIColor.label))
      .padding([.leading, .trailing], 20)
      .unredacted()
  }
}

struct MealIconView_Previews: PreviewProvider {
  static var previews: some View {
    MealIconView()
  }
}
