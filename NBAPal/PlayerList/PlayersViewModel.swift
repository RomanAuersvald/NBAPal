//
//  PlayersViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import Combine
import OSLog

@Observable
final class PlayersViewModel {
    
    var players: [Player] = []
    var searchedPlayers: [Player] = []
    var requestError: NBAPLoadingError?
    private let perPage = 35
    private var cursor = 0
    private var searchCursor: Int? = nil // default for search is none
    private var isSearchingPlayersAllLoaded: Bool = false
    private var isPlayersLoaded: Bool = false
    
    var isAllLoaded: Bool = false
    var searchText = ""
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
            Logger.networking.log("Search request for \(self.searchText) initiated")
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: searchCursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.requestError = .networkError(error: error)
                        Logger.networking.error("Search request error \(error)")
                    case .finished:
                        Logger.networking.info("Search request for \(self.searchText) finished")
                    }
                } receiveValue: { [unowned self] receivedDataWrapper in
                    guard let receivedPlayers = receivedDataWrapper.data else { return }
                    Logger.networking.log("Search fetched \(receivedPlayers.count) players")
                    self.searchedPlayers.append(contentsOf: receivedPlayers)
                    if let nextCursor = receivedDataWrapper.meta?.nextCursor {
                        self.searchCursor = nextCursor
                        Logger.networking.log("Search next cursor set for \(nextCursor)")
                    }
                    
                    if receivedPlayers.count < self.perPage {
                        self.isSearchingPlayersAllLoaded = true
                        self.isAllLoaded = true
                        Logger.networking.log("Search loaded all results")
                    }
                }
        }
        // MARK: Players Loading
        if !isSearchingActive() && !isPlayersLoaded {
            Logger.networking.log("Players request initiated")
            self.isAllLoaded = false
            cancellable = networkManager.getPlayers(perPage: perPage, cursor: cursor, searchText: searchText)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.requestError = .networkError(error: error)
                        Logger.networking.error("Players request error: \(error)")
                    case .finished:
                        Logger.networking.info("Players request finished")
                    }
                    
                } receiveValue: { [unowned self] receivedDataWrapper in
                    guard let receivedPlayers = receivedDataWrapper.data else {  return }
                    Logger.networking.log("Players request fetched \(receivedPlayers.count) players")
                    self.players.append(contentsOf: receivedPlayers)
                    if let nextCursor = receivedDataWrapper.meta?.nextCursor {
                        self.cursor = nextCursor
                        Logger.networking.log("Players next cursor set for \(nextCursor)")
                    }else {
                        self.cursor += self.perPage // failback - should not happen
                    }
                    
                    if receivedPlayers.count < self.perPage {
                        self.isPlayersLoaded = true
                        self.isAllLoaded = true
                        Logger.networking.log("Players request loaded all players")
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
