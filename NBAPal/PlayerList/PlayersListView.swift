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
    let errorOccurred = PassthroughSubject<LocalizedError, Never>()
    @State var isFirstAppear = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach (!viewModel.isSearchingActive() ? viewModel.players : viewModel.searchedPlayers, id: \.id) { player in
                    Button(action: {
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
            .alert(isPresented: Binding<Bool>(
                get: { self.viewModel.state == .failed },
                set: { _ in self.viewModel.state = .idle }
            )) {
                Alert(title: Text("Error occured"),
                      message: Text(""),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func loadNextDataBatch() {
        viewModel.fetchPlayers()
    }
}

#Preview {
    PlayersView(viewModel: PlayersViewModel(networkManager: NetworkManager.shared))
}
