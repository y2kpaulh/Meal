//
//  PlanNotiService.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/11.
//

import Foundation
#if !os(watchOS)
import WidgetKit
#endif

class PlanNotiService {
  func fetchPlanList(completion: @escaping ([MealPlan]) -> Void) {
    guard !PlanService.isOffLineMode else {
      return completion(PlanStore().mealPlan)
    }
    guard let components = URLComponents(url: PlanService.baseUrl.appendingPathComponent(PlanService.APIPath.mealPlan.rawValue), resolvingAgainstBaseURL: true)
    else { fatalError("Couldn't create URLComponents") }

    let request = URLRequest(url: components.url!)

    URLSession(configuration: .default)
      .dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        guard error == nil else {
          print("Error occur: \(String(describing: error))")
          return
        }

        guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
          return
        }
        do {
          let plan = try JSONDecoder().decode([MealPlan].self, from: data)

          DispatchQueue.main.async {
            #if !os(watchOS)
            WidgetCenter.shared.reloadTimelines(ofKind: "MealWidget")
            #endif
          }
          completion(plan)
        } catch {
          print(error.localizedDescription)
        }
      }
      .resume()
  }
}
