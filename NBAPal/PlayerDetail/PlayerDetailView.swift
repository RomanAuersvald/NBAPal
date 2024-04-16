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
            Text(viewModel.player.firstName ?? "N/A")
                .font(.title)
            Text(viewModel.player.lastName ?? "N/A")
            if let age = viewModel.player.draftYear {
                Text("Age: \(String(age))")
            } else {
                Text("Age: Unknown")
            }
            if let team = viewModel.player.team {
                Button(action: {
                    didClickPlayerClubDetail.send(team)
                }) {
                    Text("Team info")
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(viewModel.player.firstName ?? "")
    }
}

#Preview {
    PlayerDetailView(viewModel: PlayerDetailViewModel(player: MockData.shared.player))
}

