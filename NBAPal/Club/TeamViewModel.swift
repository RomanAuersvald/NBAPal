//
//  ClubViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

final class TeamViewModel: ObservableObject {
    
    var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
}
