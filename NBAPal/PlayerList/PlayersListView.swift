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
            List {
                ForEach (viewModel.players, id: \.id) { player in
                    PlayerRow(player: player)
                }
                if !viewModel.players.isEmpty {
                    LoadingView(isLoadingFail: viewModel.requestError != nil, isLoadingFinished: viewModel.isAllLoaded,
                                loadingDetail:
                                    Text("Loading Players..."),
                                
                                finishedView:
                                    Text("All players loaded.")
                                ,
                                loadinFailView:
                                    Text("Loading next Players failed. Tap to retry.")
                    )
                    .onAppear(perform: {
                        loadNextDataBatch()
                    })
                    .onTapGesture {
                        loadNextDataBatch()
                    }
                }
            }
            .onAppear(perform: {
                  loadNextDataBatch()
            })
            .navigationTitle("Players")
            .overlay {
                if viewModel.players.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("Loading Players", systemImage: "basketball.fill")
                        },
                        description: {
                            ProgressView()
                        })
                }
            }
        }
    }
    
    private func loadNextDataBatch(){
        viewModel.fetchPlayers()
    }
}

struct PlayerRow: View {
    let player: Player
    var body: some View {
        HStack (spacing: 12) {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(player.firstName ?? "")
        }
        .padding(4)
        
    }
}

#Preview {
    PlayersView(viewModel: PlayersViewModel(networkManager: NetworkManager.shared))
}
