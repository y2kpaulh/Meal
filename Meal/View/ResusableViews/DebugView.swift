//
//  DebugView.swift
//  DebugPrint
//
//  Created by Inpyo Hong on 2021/09/08.
//

import SwiftUI

//https://www.swiftbysundell.com/articles/building-swiftui-debugging-utilities/

extension View {
  func print(_ value: Any) -> Self {
    Swift.print(value)
    return self
  }
}

extension View {
  func debugAction(_ closure: () -> Void) -> Self {
    #if DEBUG
    closure()
    #endif

    return self
  }
}

extension View {
  func debugPrint(_ value: Any) -> Self {
    debugAction { print(value) }
  }
}

extension View {
  func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
    #if DEBUG
    return modifier(self)
    #else
    return self
    #endif
  }
}

extension View {
  func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
    debugModifier {
      $0.border(color, width: width)
    }
  }

  func debugBackground(_ color: Color = .red) -> some View {
    debugModifier {
      $0.background(color)
    }
  }
}
