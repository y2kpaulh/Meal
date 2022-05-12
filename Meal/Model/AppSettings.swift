//
//  AppSettings.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/05/01.
//

import Foundation

//https://narlei.com/development/how-to-create-a-settings-manager-in-swift-51/

let userDefaults = UserDefaults.standard

struct AppSettingsManager {
  static let email = "echadworks@gmail.com"

  static var dailyNotiSettingsTimeFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "a hh:mm"
    dateFormatter.locale = Locale(identifier: "ko")

    return dateFormatter
  }

  static var dailyNotiScheduleTimeFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.locale = Locale(identifier: "ko")

    return dateFormatter
  }
}

public enum AppSettings {

  // New enum with the Keys, add all settings key here
  public enum key: String {
    case isLoggedIn = "isLoggedIn"
    case isDailyNoti = "isDailyNoti"
    case dailyNotiTime = "dailyNotiTime"
  }

  public static subscript(_ key: key) -> Any? { // the parameter key have a enum type `key`
    get { // need use `rawValue` to acess the string
      return userDefaults.value(forKey: key.rawValue)
    }
    set { // need use `rawValue` to acess the string
      userDefaults.setValue(newValue, forKey: key.rawValue)
    }
  }
}

extension AppSettings {
  public static func setDefaultValue() {
    AppSettings[.isLoggedIn] = AppSettings.valueExists(forKey: "isLoggedIn") ? AppSettings.boolValue(.isLoggedIn) : false
    AppSettings[.isDailyNoti] = AppSettings.valueExists(forKey: "isDailyNoti") ? AppSettings.boolValue(.isDailyNoti) : true
    AppSettings[.dailyNotiTime] = AppSettings.valueExists(forKey: "dailyNotiTime") ? AppSettings.stringValue(.dailyNotiTime) : "오전 06:00"
  }

  public static func reset() {
    userDefaults.removeObject(forKey: "isLoggedIn")
    userDefaults.removeObject(forKey: "isDailyNoti")
    userDefaults.removeObject(forKey: "dailyNotiTime")
  }

  public static func valueExists(forKey key: String) -> Bool {
    return userDefaults.object(forKey: key) != nil
  }

  public static func boolValue(_ key: key) -> Bool {
    if let value = AppSettings[key] as? Bool {
      return value
    }
    return false
  }

  public static func stringValue(_ key: key) -> String? {
    if let value = AppSettings[key] as? String {
      return value
    }
    return nil
  }

  public static func intValue(_ key: key) -> Int? {
    if let value = AppSettings[key] as? Int {
      return value
    }
    return nil
  }
}

//https://cocoacasts.com/ud-7-how-to-check-if-a-value-exists-in-user-defaults-in-swift
extension UserDefaults {
  func valueExists(forKey key: String) -> Bool {
    return object(forKey: key) != nil
  }
}
