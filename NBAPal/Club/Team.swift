//
//  Club.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation


struct Team: Identifiable, Codable {
    let id: Int?
    let conference, division, city, name: String?
    let fullName, abbreviation: String?
}
