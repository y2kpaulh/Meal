//
//  Service.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation
import Combine

enum PlanService {
  static let isOffLineMode = true
  static let apiClient = APIClient()
  static let baseUrl = URL(string: "https://api.jsonbin.io")!

  enum APIPath: String {
    case planList = "/b/6113a4a9d5667e403a3fcb69"
  }
}

extension PlanService {
  static func requestPlan(_ path: PlanService.APIPath) -> AnyPublisher<[Plan], Error> {
    guard !self.isOffLineMode else {
      return Just(PlanStore().planList)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }

    guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
    else { fatalError("Couldn't create URLComponents") }
    //        components.queryItems = [URLQueryItem(name: "api_key", value: "dcecee71c76cbecc1c254aae96bea9a4")] // 4

    let request = URLRequest(url: components.url!)

    return apiClient.run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
