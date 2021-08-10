//
//  TodayMealViewModel.swift
//  Meal
//
//  Created by Inpyo Hong on 2021/08/10.
//

import Foundation
import Combine

class TodayMealViewModel: ObservableObject {
    @Published var plans: [Plan] = []
    @Published var todayPlan: Plan = Plan(day: "", book: "", fChap: 0, fVer: 0, lChap: 0, lVer: 0)
    @Published var todayPlanData: PlanData = PlanData(book: "", verses: [])
    @Published var loading = false
    @Published var planDataError: Bool = false
    
    var cancelBag = Set<AnyCancellable>()
    
    init() {
        getPlanData()
    }
}

extension TodayMealViewModel {
    func getPlanData() {
        self.loading = true
        
        PlanService.requestPlan(.planList)
//            .map{
//                PlanStore().getPlanData(plan: $0.filter{ $0.day == PlanStore().getFormattedDateStr() }[0])
//            }
            .mapError(
                { (error) -> Error in
                    print(error)
                    self.planDataError = true
                    DispatchQueue.main.async {
                        self.loading = false
                    }
                    return error
                })
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                    DispatchQueue.main.async {
                        self.loading = false
                    }
                }
            },
            receiveValue: {
                self.plans = $0
                self.todayPlan = $0.filter{ $0.day == PlanStore().getFormattedDateStr() }[0]
                self.todayPlanData = PlanStore().getPlanData(plan: self.todayPlan)
                DispatchQueue.main.async {
                    self.loading = false
                }
                //print($0)
            })
            .store(in: &cancelBag)
    }
}
