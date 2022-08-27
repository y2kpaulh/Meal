//
//  NotificationCenter.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/03/26.
//

import Foundation

extension NSNotification.Name {
  static let activePhaseNotification = NSNotification.Name("activePhaseNotification")
  static let inactivePhaseNotification = NSNotification.Name("inactivePhaseNotification")
  static let backgroundPhaseNotification = NSNotification.Name("backgroundPhaseNotification")
  static let changedDayNotification = NSNotification.Name("changedDayNotification")
  static let widgetDeepLinkNotification = NSNotification.Name("widgetDeepLinkNotification")
}
