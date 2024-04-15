//
//  PlayersViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Combine

final class PlayersViewModel: ObservableObject {
    @Published var players: [Player] = []
    
    func fetchPlayers() {
        self.players = [
            Player(id: 1, name: "Player 1", clubID: 1),
            Player(id: 2, name: "Player 2", clubID: 2),
            Player(id: 3, name: "Player 3", clubID: 3)
        ]
    }
}
