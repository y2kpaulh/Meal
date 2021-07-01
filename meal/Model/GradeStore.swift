//
//  GradeStore.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation

struct Grade: Codable, Identifiable {
    var id: String
    var subject: String
    var grade: String
}

class GradeStore: ObservableObject {
    @Published var grades: [Grade]
    
    init (grades: [Grade] = []) {
        self.grades = grades
    }
}
