/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Storage for model data.
 */

import Foundation
import Combine

final class ModelData: ObservableObject {
  @Published var planList = [Plan]()// = load("mealPlan.json")

  //    var features: [Landmark] {
  //        landmarks.filter { $0.isFeatured }
  //    }
  //
  //    var categories: [String: [Landmark]] {
  //        Dictionary(
  //            grouping: landmarks,
  //            by: { $0.category.rawValue }
  //        )
  //    }
}

func load<T: Decodable>(_ filename: String) -> T {
  let data: Data

  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
  else {
    fatalError("Couldn't find \(filename) in main bundle.")
  }

  do {
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
  }

  do {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}

func readMealPlanFile(fileName: String) throws -> [Plan]? {
  do {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      let url = dir.appendingPathComponent(fileName)
      let data = try Data(contentsOf: url)
      let decoded = try JSONDecoder().decode([Plan].self, from: data)

      return decoded
    } else {
      return nil
    }
  } catch {
    throw error
  }
}

extension Array where Element: Encodable {
  func saveToFile(fileName: String) throws {
    do {
      let data = try JSONEncoder().encode(self)
      if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(fileName)
        try data.write(to: fileURL)
      } else {
        //throw some error
      }
    } catch {
      throw error
    }
  }
}
