//
//  ViewExtension.swift
//  Meal
//
//  Created by Inpyo Hong on 11/5/23.
//

import Foundation
import SwiftUI
extension View {
  func widgetBackground(backgroundView: some View) -> some View {
    if #available(iOS 17.0, *) {
      return containerBackground(for: .widget) {
        backgroundView
      }
    } else {
      return background(backgroundView)
    }
  }
}
