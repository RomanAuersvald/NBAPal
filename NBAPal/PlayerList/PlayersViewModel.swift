//
//  PlayersViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import Combine

final class PlayersViewModel: ObservableObject {
    
    enum PlayersVMLoadingState {
        case idle
        case loading
        case finished
        case failed(error: Error)
    }
    
    
    
    @Published var players: [Player] = []
    @Published var requestError: Error?
    private var state: PlayersVMLoadingState = .idle
    private let perPage = 35
    private var cursor = 0
    @Published var isAllLoaded: Bool = false
    
    let networkManager: NetworkManager
    
    private var cancellable: AnyCancellable?
    
    
    init(networkManager: NetworkManager){
        self.networkManager = networkManager
    }
    
    
    func fetchPlayers() {
//        self.players = [
//            Player(id: 1, name: "Player 1", clubID: 1),
//            Player(id: 2, name: "Player 2", clubID: 2),
//            Player(id: 3, name: "Player 3", clubID: 3)
//        ]
        if !isAllLoaded {
            state = .loading
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: cursor)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion{
                    case .failure(let error):
                        print(error)
                        self.requestError = error
                        self.state = .failed(error: error)
                    case .finished:
                        print("finished")
                    }
                    
                } receiveValue: { receivedDataWrapper in
                    guard let players = receivedDataWrapper.data else { self.state = .idle; return }
                    self.players.append(contentsOf: players)
                    self.cursor += self.perPage
                    self.state = .finished
                    
                    if players.count < self.perPage {
                        self.isAllLoaded = true
                    }
                }
        }
    }
}
