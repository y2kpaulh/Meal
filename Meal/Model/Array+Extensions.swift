//
//  Array+Extensions.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/05/10.
//

import Foundation

extension Array {
  func indexExists(_ index: Int) -> Bool {
    return self.indices.contains(index)
  }
}
