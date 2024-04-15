//
//  Player.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

struct Player: Identifiable, Codable {
    let id: Int?
        let firstName, lastName, position, height: String?
        let weight, jerseyNumber, college, country: String?
        let draftYear, draftRound, draftNumber: Int?
        let team: Team?
}
