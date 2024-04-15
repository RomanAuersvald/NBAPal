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
    
    init(){
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        let playersViewModel = PlayersViewModel()
        let view = PlayersView(viewModel: playersViewModel)
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
    }
    
    private func bind(view: PlayerDetailView) {
        view.didClickPlayerClubDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] player in
                self?.showClubView(for: player.id)
            })
            .store(in: &cancellables)
    }
    
}

// MARK: Navigation Related Extensions
extension PlayersCoordinator {
    private func showPlayerDetail(for player: Player) {
        let viewModel = PlayerDetailViewModel(playerID: player.id ?? 0)
        let playerDetailView = PlayerDetailView(viewModel: viewModel)
        bind(view: playerDetailView)
        rootViewController.pushViewController(UIHostingController(rootView: playerDetailView), animated: true)
    }
    
    private func showClubView(for id: Int) {
        let viewModel = ClubViewModel(clubID: id)
        let clubView = ClubView(viewModel: viewModel)
        rootViewController.pushViewController(UIHostingController(rootView: clubView), animated: true)
    }
}
