//
//  ClubView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine

struct ClubView: View {
    
    @StateObject var viewModel: ClubViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.club?.name ?? "N/A")
                .font(.title)
            Spacer()
        }
        .padding()
        .navigationBarTitle("Club DETAILS")
        .onAppear {
            viewModel.fetchClubDetails()
        }
    }
}

#Preview {
    ClubView(viewModel: ClubViewModel(clubID: 0))
}
