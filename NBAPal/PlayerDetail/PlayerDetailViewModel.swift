//
//  PlayerDetailViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

final class PlayerDetailViewModel: ObservableObject {
    
    @Published var profile: PlayerDetail?
    
    private var playerID: Int
    
    init(playerID: Int) {
        self.playerID = playerID
    }
    
    func fetchProfile() {
        self.profile = PlayerDetail(id: 05,
                                    name: "Jone Doe",
                                    age: 25, clubID: 9)
    }
}
