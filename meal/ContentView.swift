//
//  ContentView.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gradeStore: GradeStore

    init() {
        let gradeData: [Grade] = loadJson("gradeData.json")
        gradeStore = GradeStore(grades: gradeData)
    }
    
    var body: some View {
        List(gradeStore.grades) { grade in
            HStack {
                Text(grade.subject)
                    .font(.largeTitle)
                Text(grade.grade)
                    .font(.headline)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
