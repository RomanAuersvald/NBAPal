//
//  MockData.swift
//  NBAPal
//
//  Created by Roman Auersvald on 16.04.2024.
//

import Foundation


public class MockData {
    
    public static let shared = MockData()
    
    let team = Team(id: 0, conference: "West", division: "Pacific", city: "Golden State", name: "Warriors", fullName: "Golden State Warriors", abbreviation: "GSW")
    
    let player = Player(id: 0, firstName: "FirstName", lastName: "LastName", position: "F", height: "6'1", weight: "123", jerseyNumber: "49", college: "College", country: "Country", draftYear: 0000, draftRound: 0, draftNumber: 0, team: Team(id: 0, conference: "", division: "", city: "", name: "TeamName", fullName: "TeamFullName", abbreviation: "TFN"))
}


