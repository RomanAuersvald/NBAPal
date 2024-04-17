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
            PlayerDetailHeader(player: viewModel.player)
            
            ZStack {
                VStack {
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
                            Text("Draft Year")
                            Spacer()
                            Text(viewModel.player.draftYear?.description ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Draft Round")
                            Spacer()
                            Text(viewModel.player.draftRound?.description ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Draft Number")
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
    
    var body: some View {
        ZStack {
            Color.gray
            Image(systemName: "person.fill") // figure.basketball
                .resizable()
                .scaledToFit()
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
            VStack {
                Spacer()
                HStack {
                    Text(player.firstName ?? "N/A")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    Text(player.lastName ?? "N/A")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(5)
            }
        }
        .frame(minHeight: 200, maxHeight: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    PlayerDetailView(viewModel: PlayerDetailViewModel(player: MockData.shared.player))
}

