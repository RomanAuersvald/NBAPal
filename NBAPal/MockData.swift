//
//  MockData.swift
//  NBAPal
//
//  Created by Roman Auersvald on 16.04.2024.
//

import Foundation


public class MockData {
    
    public static let shared = MockData()
    
    let team = Team(id: 0, conference: "", division: "", city: "", name: "TeamName", fullName: "TeamFullName", abbreviation: "TFN")
    
    let player = Player(id: 0, firstName: "FirstName", lastName: "LastName", position: "F", height: "", weight: "", jerseyNumber: "", college: "", country: "", draftYear: 0000, draftRound: 0, draftNumber: 0, team: Team(id: 0, conference: "", division: "", city: "", name: "TeamName", fullName: "TeamFullName", abbreviation: "TFN"))
}


