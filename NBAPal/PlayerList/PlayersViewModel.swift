//
//  PlayersViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import Combine


final class PlayersViewModel: ObservableObject {
    
    enum PlayersVMLoadingState: Equatable {
        case idle
        case loading
        case finished
        case failed
    }
    
    @Published var players: [Player] = []
    @Published var searchedPlayers: [Player] = []
    @Published var requestError: Error?
    @Published var state: PlayersVMLoadingState = .idle
    private let perPage = 35
    private var cursor = 0
    private var searchCursor: Int? = nil // default for search is none
    private var isSearchingPlayersAllLoaded: Bool = false
    private var isPlayersLoaded: Bool = false
    
    @Published var isAllLoaded: Bool = false
    @Published var searchText = ""
    private var lastSearchText = ""
    
    let networkManager: NetworkManager
    
    private var cancellable: AnyCancellable?
    
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    private func searching() -> Bool {
        return !searchText.isEmpty
    }
    
    func fetchPlayers() {
        if searchText != lastSearchText {
            lastSearchText = searchText
            self.searchedPlayers.removeAll()
            self.isAllLoaded = false
            self.isPlayersLoaded = false
            self.isSearchingPlayersAllLoaded = false
        }
        if searching() && !isSearchingPlayersAllLoaded {
            state = .loading
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: searchCursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self.requestError = error
                        self.state = .failed
                    case .finished:
                        print("finished")
                    }
                } receiveValue: { [unowned self] receivedDataWrapper in
                    guard let receivedPlayers = receivedDataWrapper.data else { self.state = .idle; return }
                    
                    self.searchedPlayers.append(contentsOf: receivedPlayers)
                    if let nextCursor = receivedDataWrapper.meta?.nextCursor {
                        self.searchCursor = nextCursor
                    }
                    self.state = .finished
                    
                    if receivedPlayers.count < self.perPage {
                        self.isSearchingPlayersAllLoaded = true
                        self.isAllLoaded = true
                    }
                }
        }
        
        if !searching() && !isPlayersLoaded {
            self.isAllLoaded = false
            state = .loading
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: cursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self.requestError = error
                        self.state = .failed
                    case .finished:
                        print("finished")
                    }
                    
                } receiveValue: { [unowned self] receivedDataWrapper in
                    guard let receivedPlayers = receivedDataWrapper.data else { self.state = .idle; return }
                    
                    self.players.append(contentsOf: receivedPlayers)
                    if let nextCursor = receivedDataWrapper.meta?.nextCursor {
                        self.cursor = nextCursor
                    }else {
                        self.cursor += self.perPage // failback - should not happen
                    }
                    self.state = .finished
                    
                    if receivedPlayers.count < self.perPage {
                        self.isPlayersLoaded = true
                        self.isAllLoaded = true
                    }
                }
        }
    }
}
