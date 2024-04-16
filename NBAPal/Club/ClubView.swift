//
//  ClubView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine

struct ClubView: View {
    
    @StateObject var viewModel: TeamViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.team.fullName ?? "N/A")
                .font(.title)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Club DETAILS")
    }
}

#Preview {
    ClubView(viewModel: TeamViewModel(team: MockData.shared.team))
}
