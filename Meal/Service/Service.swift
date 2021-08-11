//
//  Service.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation
import Combine

func loadJson<BibleBook: Decodable>(_ filename: String) -> BibleBook {
  let data: Data

  // Bundle 에서 파일이름을 통하여 파일의 주소를 가져온다.
  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
  else {
    fatalError("\(filename) not found.")
  }

  do {
    // 위에서 가져온 주소를 활용하여 Data structure 의 객체를 생성한다.
    // 이는 데이터를 Json decoding 에 활용할 수 있도록 하는 작업이라고 볼 수 있다.
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Could not load \(filename): \(error)")
  }

  do {
    // parse the data
    return try JSONDecoder().decode(BibleBook.self, from: data)
  } catch {
    fatalError("Unable to parse \(filename): \(error)")
  }
}

enum PlanService {
  static let apiClient = APIClient()
  static let baseUrl = URL(string: "https://api.jsonbin.io")!

  enum APIPath: String {
    case planList = "/b/61139e3cd5667e403a3fc291"
  }
}

extension PlanService {
  static func requestPlan(_ path: PlanService.APIPath) -> AnyPublisher<[Plan], Error> {
    // 3
    guard let components = URLComponents(url: baseUrl.appendingPathComponent(path.rawValue), resolvingAgainstBaseURL: true)
    else { fatalError("Couldn't create URLComponents") }
    //        components.queryItems = [URLQueryItem(name: "api_key", value: "dcecee71c76cbecc1c254aae96bea9a4")] // 4

    let request = URLRequest(url: components.url!)

    return apiClient.run(request)
      .map(\.value)
      .eraseToAnyPublisher()
  }
}
