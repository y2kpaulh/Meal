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
    
    func todayPlan() -> MealPlan? {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: nowDate)

        let todayPlan = self.plan.filter{ $0.day == today }
        
        return todayPlan[0]
    }
}
