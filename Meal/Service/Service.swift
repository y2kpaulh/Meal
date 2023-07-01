//
//  Service.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation
import Combine

enum PlanService {
  static let isOffLineMode = false
  static let apiClient = APIClient()
  static let baseUrl = URL(string: "https://mealplan-y2kpaulh.koyeb.app")!

  enum APIPath: String {
    case readingPlan = "/readingPlan"

    case mealPlan = "/mealPlan"
  }
}

extension PlanService {
  static func requestPlan(_ path: PlanService.APIPath) -> AnyPublisher<ReadingPlan, Error> {
    //    guard !self.isOffLineMode else {
    //      return Just(PlanStore().mealPlan)
    //        .setFailureType(to: Error.self)
    //        .eraseToAnyPublisher()
    //    }

    guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
    else { fatalError("Couldn't create URLComponents") }
    let request = URLRequest(url: components.url!)

    return apiClient.run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
