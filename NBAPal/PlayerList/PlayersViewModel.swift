//
//  PlayersViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import Combine

final class PlayersViewModel: ObservableObject {
    
    @Published var players: [Player] = []
    @Published var requestError: Error?
    private let perPage = 35
    private var cursor = 0
    
    private var cancellable: AnyCancellable?
    
    func fetchPlayers() {
//        self.players = [
//            Player(id: 1, name: "Player 1", clubID: 1),
//            Player(id: 2, name: "Player 2", clubID: 2),
//            Player(id: 3, name: "Player 3", clubID: 3)
//        ]
        
        cancellable = NetworkManager.shared.getPlayers(perPage: perPage, cursor: cursor)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print(error)
                    self.requestError = error
                case .finished:
                    print("finished")
                }
                
            } receiveValue: { players in
                self.players.append(contentsOf: players.data!)
                self.cursor += self.perPage
            }
        
    }
}
