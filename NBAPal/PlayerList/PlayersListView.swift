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
    let isShowingPlayerID = NBAPalConfiguration().isShowingPlayerID
    @State var isFirstAppear = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach (!viewModel.isSearchingActive() ? viewModel.players : viewModel.searchedPlayers, id: \.id) { player in
                    Button(action: {
//                        Logger.userInteraction.log("Clicked \(player.fullName)")
                        didClickPlayer.send(player)
                    }, label: {
                        PlayerListRow(player: player, isShowPlayerID: isShowingPlayerID)
                    })
                    .buttonStyle(.plain)
                    
                }
                if !viewModel.isSearchingActive() ? !viewModel.players.isEmpty : !viewModel.searchedPlayers.isEmpty {
                    LoadingView(isLoadingFail: viewModel.requestError != nil, isLoadingFinished: viewModel.isAllLoaded,
                                loadingDetail:
                                    Text(LocalizedStringKey("Loading")),
                                finishedView:
                                    Text(LocalizedStringKey("PlayersLoaded"))
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
            .navigationTitle(LocalizedStringKey("Players"))
//            .toolbar{
//                ToolbarItem(placement: .topBarLeading) {
//                    Image(systemName: "basketball.fill")
//                        .tint(.orange)
//                }
//            }
            .overlay {
                if viewModel.players.isEmpty && viewModel.requestError == nil {
                    ContentUnavailableView(
                        label: {
                            Label(LocalizedStringKey("LoadingPlayers"), systemImage: "basketball.fill")
                        },
                        description: {
                            ProgressView()
                        })
                }
                if viewModel.isSearchingActive() && viewModel.searchedPlayers.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(LocalizedStringKey("SearchForPlayers"), systemImage: "magnifyingglass.circle.fill")
                        },
                        description: {
                            Text(LocalizedStringKey("PressGoToSearch"))
                        })
                }
                if viewModel.requestError != nil && (viewModel.players.isEmpty || viewModel.searchedPlayers.isEmpty){
                    ContentUnavailableView(
                        label: {
                            Label(LocalizedStringKey("NoNetwork"), systemImage: "network.slash")
                        },
                        description: {
                            Text(LocalizedStringKey("CheckInternetTryAgain"))
                        })
                }
            }
            .searchable(text: $viewModel.searchText)
            .onSubmit(of: .search) {
                viewModel.fetchPlayers()
            }
            .onChange(of: viewModel.requestError, {
                if viewModel.requestError != nil {
                    errorOccurred.send(viewModel.requestError!)
                }
            })
            .refreshable {
                viewModel.fetchPlayers()
            }
        }
    }
    
    private func loadNextDataBatch() {
        viewModel.fetchPlayers()
    }
}

#Preview {
    PlayersView(viewModel: PlayersViewModel(networkManager: NBAPalNetworkManager.shared))
}
