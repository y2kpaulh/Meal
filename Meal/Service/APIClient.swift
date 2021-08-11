//
//  APIClient.swift
//  CombineDemo
//
//  Created by Inpyo Hong on 2021/08/09.
//

import Foundation
import Combine

struct APIClient {
  struct Response<T> {
    let value: T
    let response: URLResponse
  }

  func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .retry(3)
      .tryMap { result -> Response<T> in
        let value = try JSONDecoder().decode(T.self, from: result.data)
        return Response(value: value, response: result.response)
      }
      .receive(on: DispatchQueue.global(qos: .background))
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}
