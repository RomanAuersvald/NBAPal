//
//  PlayersCoordinator.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import SwiftUI
import Combine

class PlayersCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    
    let sharedViewModel: PlayersViewModel
    
    init(){
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        sharedViewModel = PlayersViewModel(networkManager: NetworkManager.shared)
    }
    
    func start() {
        let view = PlayersView(viewModel: self.sharedViewModel)
        bind(view: view)
        let navigationViewController = UINavigationController(rootViewController: UIHostingController(rootView: view))
        rootViewController = navigationViewController
    }
    
    // MARK: View Bindings
    private func bind(view: PlayersView) {
        view.didClickPlayer
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] player in
                self?.showPlayerDetail(for: player)
            })
            .store(in: &cancellables)
        
        view.errorOccurred
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] localizedError in
                self?.showErrorAlert(with: localizedError)
            })
            .store(in: &cancellables)
    }
    
    private func bind(view: PlayerDetailView) {
        view.didClickPlayerClubDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] team in
                self?.showTeamView(for: team)
            })
            .store(in: &cancellables)
    }
    
}

// MARK: Navigation Related Extension
extension PlayersCoordinator {
    
    private func showErrorAlert(with error: LocalizedError){ //LocalizedError
        let alertController = UIAlertController(title: error.failureReason, message: error.errorDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in }))
        rootViewController.topViewController?.present(alertController, animated: true)
    }
    
    private func showPlayerDetail(for player: Player) {
        let viewModel = PlayerDetailViewModel(player: player)
        let playerDetailView = PlayerDetailView(viewModel: viewModel)
        bind(view: playerDetailView)
        rootViewController.pushViewController(UIHostingController(rootView: playerDetailView), animated: true)
    }
    
    private func showTeamView(for team: Team) {
        let viewModel = TeamViewModel(team: team)
        let clubView = TeamView(viewModel: viewModel)
        rootViewController.pushViewController(UIHostingController(rootView: clubView), animated: true)
    }
}
