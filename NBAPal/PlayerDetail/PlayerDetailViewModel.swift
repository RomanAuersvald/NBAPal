//
//  PlayerDetailViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation

final class PlayerDetailViewModel: ObservableObject {
    
    var player: Player
    
    init(player: Player) {
        self.player = player
    }
    
}
