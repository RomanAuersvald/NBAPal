//
//  PlayersListView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine

struct PlayersView: View {
    
    @StateObject var viewModel: PlayersViewModel
    let didClickPlayer = PassthroughSubject<Player, Never>()
    
    var body: some View {
        NavigationView {
                    List(viewModel.players) { player in
                        Button(action: {
                            didClickPlayer.send(player)
                        }) {
                            Text(player.name)
                        }
                    }
                    .navigationBarTitle("Players")
                    .onAppear {
                        viewModel.fetchPlayers()
                    }
                }
    }
}

#Preview {
    PlayersView(viewModel: PlayersViewModel())
}
