//
//  ClubViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

final class ClubViewModel: ObservableObject {
    
    @Published var club: Team?
    
    private var clubID: Int
    
    init(clubID: Int) {
        self.clubID = clubID
    }
    
    func fetchClubDetails() {
//        self.club = Team(id: 0, name: "Generic club")
        
        
    }
}
