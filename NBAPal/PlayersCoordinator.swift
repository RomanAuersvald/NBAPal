//
//  PlayersCoordinator.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import SwiftUI
import Combine
import OSLog

class PlayersCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    
    let sharedViewModel: PlayersViewModel
    
    init(){
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        sharedViewModel = PlayersViewModel(networkManager: NetworkManager.shared)
        Logger.navigation.log("Player coordinator initialized")
    }
    
    func start() {
        let view = PlayersView(viewModel: self.sharedViewModel)
        bind(view: view)
        let navigationViewController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        rootViewController = navigationViewController
        Logger.navigation.log("Player coordinator started")
    }
    
    // MARK: View Bindings
    private func bind(view: PlayersView) {
        view.didClickPlayer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] player in
                Task { @MainActor in
                    self.showPlayerDetail(for: player)
                }
            })
            .store(in: &cancellables)
        
        view.errorOccurred
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] localizedError in
                self?.showErrorAlert(with: localizedError)
            })
            .store(in: &cancellables)
        Logger.navigation.log("Binded PlayersListView actions")
    }
    
    private func bind(view: PlayerDetailView) {
        view.didClickPlayerClubDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] team in
                Task { @MainActor in
                    self.showTeamView(for: team)
                }
            })
            .store(in: &cancellables)
        Logger.navigation.log("Binded PlayerDetailView actions")
    }
    
}

// MARK: Navigation Related Extension
extension PlayersCoordinator {
    
    private func showErrorAlert(with error: LocalizedError){
        Logger.navigation.warning("Showing error alert")
        let alertController = UIAlertController(title: error.failureReason, message: error.errorDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in }))
        rootViewController.topViewController?.present(alertController, animated: true)
    }
    
    @MainActor private func showPlayerDetail(for player: Player) {
        Logger.navigation.log("Navigating to PlayerDetailView")
        let viewModel = PlayerDetailViewModel(player: player)
        let playerDetailView = PlayerDetailView(viewModel: viewModel)
        bind(view: playerDetailView)
        rootViewController.pushViewController(UIHostingController(rootView: playerDetailView), animated: true)
    }
    
    @MainActor private func showTeamView(for team: Team) {
        Logger.navigation.log("Navigating to TeamView")
        let viewModel = TeamViewModel(team: team)
        let clubView = TeamView(viewModel: viewModel)
        rootViewController.pushViewController(UIHostingController(rootView: clubView), animated: true)
    }
}
