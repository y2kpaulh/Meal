//
//  PlanStore.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/07/09.
//

import Foundation

class PlanStore: ObservableObject {
    @Published var plan: [MealPlan] = []
    
    init (plan: [MealPlan] = []) {
        self.plan = plan
    }
}
