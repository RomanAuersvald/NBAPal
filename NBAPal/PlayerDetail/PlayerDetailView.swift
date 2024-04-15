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
    let didClickPlayerClubDetail = PassthroughSubject<PlayerDetail, Never>()
    
    var body: some View {
        VStack {
            Text(viewModel.profile?.name ?? "N/A")
                .font(.title)
            if let age = viewModel.profile?.age {
                Text("Age: \(String(age))")
            } else {
                Text("Age: Unknown")
            }
            if let profile = viewModel.profile {
                Button(action: {
                    didClickPlayerClubDetail.send(profile)
                }) {
                    Text("Club info")
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(viewModel.profile?.name ?? "")
        .onAppear {
            viewModel.fetchProfile()
        }
    }
}

#Preview {
    PlayerDetailView(viewModel: PlayerDetailViewModel(playerID: 0))
}

