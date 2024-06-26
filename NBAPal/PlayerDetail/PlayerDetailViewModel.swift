//
//  PlayerDetailViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

@MainActor
final class PlayerDetailViewModel: ObservableObject {
    
    var player: Player
    
    let playerImages = ["person.fill", "figure.basketball"]
    
    init(player: Player) {
        self.player = player
    }
    
}
