//
//  HighScoreEntry.swift
//  simonGame
//
//  Created by Zhang, Xiaoyi [sgxzh104] on 10/11/2023.
//

import Foundation
//Create a sturcture for recording! It is shared to two View Controller!
struct HighScoreEntry: Codable {
    var name: String
    var score: Int
    var date: Date
}
