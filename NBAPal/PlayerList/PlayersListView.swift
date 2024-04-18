//
//  PlayersListView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine
import OSLog

struct PlayersView: View {
    
    @State var viewModel: PlayersViewModel
    let didClickPlayer = PassthroughSubject<Player, Never>()
    let errorOccurred = PassthroughSubject<LocalizedError, Never>()
    @State var isFirstAppear = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach (!viewModel.isSearchingActive() ? viewModel.players : viewModel.searchedPlayers, id: \.id) { player in
                    Button(action: {
//                        Logger.userInteraction.log("Clicked \(player.fullName)")
                        didClickPlayer.send(player)
                    }, label: {
                        PlayerListRow(player: player)
                    })
                    .buttonStyle(.plain)
                    
                }
                if !viewModel.isSearchingActive() ? !viewModel.players.isEmpty : !viewModel.searchedPlayers.isEmpty {
                    LoadingView(isLoadingFail: viewModel.requestError != nil, isLoadingFinished: viewModel.isAllLoaded,
                                loadingDetail:
                                    Text("Loading Players..."),
                                finishedView:
                                    Text("All players loaded.")
                                ,
                                loadinFailView:
                                    Text(viewModel.requestError?.errorDescription ?? "")
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
                if isFirstAppear {
                    Logger.userInteraction.log("First appearance of PlayersListView, loading first batch.")
                    loadNextDataBatch()
                    isFirstAppear = false
                }
            })
            .navigationTitle("Players")
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Image(systemName: "basketball.fill")
                        .tint(.orange)
                }
            }
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
                if !viewModel.searchText.isEmpty && viewModel.searchedPlayers.isEmpty{
                    ContentUnavailableView(
                        label: {
                            Label("Search for players", systemImage: "magnifyingglass.circle.fill")
                        },
                        description: {
                            Text("Press GO to search")
                        })
                }
            }
            .searchable(text: $viewModel.searchText)
            .onSubmit(of: .search) {
                viewModel.fetchPlayers()
            }
            .onChange(of: viewModel.requestError, {
                errorOccurred.send(viewModel.requestError!)
            })
        }
    }
    
    private func loadNextDataBatch() {
        viewModel.fetchPlayers()
    }
}

#Preview {
    PlayersView(viewModel: PlayersViewModel(networkManager: NetworkManager.shared))
}
