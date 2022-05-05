//
//  SettingsViewModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2022/03/20.
//

import Foundation
import Combine

struct Settings: Identifiable, Hashable {
  let id = UUID()
  let item: [String: String]
}

class SettingsViewModel: ObservableObject {
  @Published var settingsList: [Settings] = [Settings(item: ["key": "Value"])]
  @Published var isLoading = false

  var cancelBag = Set<AnyCancellable>()

  init() {
    isLoadingPublisher
      .receive(on: RunLoop.main)
      .assign(to: \.isLoading, on: self)
      .store(in: &cancelBag)
  }

  private var isLoadingPublisher: AnyPublisher<Bool, Never> {
    self.$isLoading
      .receive(on: RunLoop.main)
      .map { $0 }
      .eraseToAnyPublisher()
  }
}
