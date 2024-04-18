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
    @Published var requestError: NBAPLoadingError?
    @Published var state: PlayersVMLoadingState = .idle
    private let perPage = 35
    private var cursor = 0
    private var searchCursor: Int? = nil // default for search is none
    private var isSearchingPlayersAllLoaded: Bool = false
    private var isPlayersLoaded: Bool = false
    
    @Published var isAllLoaded: Bool = false
    @Published var searchText = ""
    private var lastSearchText = ""
    
    private let networkManager: NetworkManager
    
    private var cancellable: AnyCancellable?
    
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func isSearchingActive() -> Bool {
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
        // MARK: Player Search Loading
        if isSearchingActive() && !isSearchingPlayersAllLoaded {
            state = .loading
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: searchCursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self.requestError = .networkError(error: error)
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
        // MARK: Players Loading
        if !isSearchingActive() && !isPlayersLoaded {
            self.isAllLoaded = false
            state = .loading
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: cursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self.requestError = .networkError(error: error)
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

enum NBAPLoadingError: LocalizedError, Equatable {
    
    static func == (lhs: NBAPLoadingError, rhs: NBAPLoadingError) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
    
    
    case networkError(error: Error?)
    case noDataResponse
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "There seems to be problem with network connection. Try again later."
        case .noDataResponse:
            return "Server returned no data."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkError, .noDataResponse:
            return "Could not load Players"
        }
    }
}
