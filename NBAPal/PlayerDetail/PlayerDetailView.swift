//
//  PlayerDetailView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine

struct PlayerDetailView: View {
    
    @StateObject var viewModel: PlayerDetailViewModel
    let didClickPlayerClubDetail = PassthroughSubject<Team, Never>()
    
    var body: some View {
        VStack {
            PlayerDetailHeader(player: viewModel.player, playerImages: viewModel.playerImages)
            
            ZStack {
                VStack {
                    
                    VStack {
                        HStack {
                            Text(viewModel.player.firstName ?? "N/A")
                                .font(.largeTitle)
                                .bold()
                                .lineLimit(2)
                            Spacer()
                        }.padding(.horizontal)
                        HStack {
                            Text(viewModel.player.lastName ?? "N/A")
                                .font(.largeTitle)
                                .bold()
                                .lineLimit(2)
                            Spacer()
                        }.padding(.horizontal)
                    }
                    VStack {
                        Text("Personal")
                            .textCase(.uppercase)
                            .bold()
                        HStack {
                            Text("Height")
                            Spacer()
                            Text(viewModel.player.height ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Weight")
                            Spacer()
                            Text(viewModel.player.weight ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("College")
                            Spacer()
                            Text(viewModel.player.college ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Country")
                            Spacer()
                            Text(viewModel.player.country ?? "N/A")
                        }.padding(.horizontal)
                    }
                    Divider()
                    
                    VStack {
                        Text("Draft")
                            .textCase(.uppercase)
                            .bold()
                        HStack {
                            Text("DraftYear")
                            Spacer()
                            Text(viewModel.player.draftYear?.description ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("DraftRound")
                            Spacer()
                            Text(viewModel.player.draftRound?.description ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("DraftNumber")
                            Spacer()
                            Text(viewModel.player.draftNumber?.description ?? "N/A")
                        }.padding(.horizontal)
                    }
                    Divider()
                    
                    VStack {
                        Text("Team")
                            .textCase(.uppercase)
                            .bold()
                        HStack {
                            Text(viewModel.player.team?.fullName ?? "N/A")
                            Spacer()
                            if let team = viewModel.player.team {
                                Button(action: {
                                    didClickPlayerClubDetail.send(team)
                                }) {
                                    Text("Detail")
                                        .textCase(.uppercase)
                                }
                            }
                        }.padding(.horizontal)
                        
                    }
                    Divider()
                }
            }
            Spacer()
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .ignoresSafeArea(.all)
        .padding()
        .navigationBarTitle(viewModel.player.firstName ?? "")
    }
}
//Text(player.team?.fullName ?? "")

struct PlayerDetailHeader: View {
    
    let player: Player
    let playerImages: [String]
    
    var body: some View {
        ZStack {
            PageGallery(images: playerImages)
                .frame(minHeight: 220)
            VStack(alignment: .trailing) {
                HStack {
                    Text(player.jerseyNumber ?? "N/A")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .bold()
                    Spacer()
                    Text(player.position ?? "N/A")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .bold()
                }.padding()
                Spacer()
            }
        }
        .frame(minHeight: 200, maxHeight: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PlayerDetailView(viewModel: PlayerDetailViewModel(player: MockData.shared.player))
        .environment(\.locale, .init(identifier: "cs"))
}

