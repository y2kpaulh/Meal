//
//  Bible.swift
//  meal
//
//  Created by Inpyo Hong on 2021/07/01.
//

import Foundation

struct Chapter: Codable {
    let abbrev: String
    let chapters: [String]
    let name: String
}

struct Bible: Codable {
    let chapter: [Chapter]
}
