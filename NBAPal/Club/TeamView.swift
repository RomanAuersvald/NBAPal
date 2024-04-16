//
//  ClubView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine

struct TeamView: View {
    
    @StateObject var viewModel: TeamViewModel
    
    var body: some View {
        VStack {
            TeamHeader(team: viewModel.team)
            
            ZStack {
                VStack {
                    VStack {
                        Text("Info")
                            .textCase(.uppercase)
                            .bold()
                        HStack {
                            Text("Conference")
                            Spacer()
                            Text(viewModel.team.conference ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Division")
                            Spacer()
                            Text(viewModel.team.division ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("City")
                            Spacer()
                            Text(viewModel.team.city ?? "N/A")
                        }.padding(.horizontal)
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(viewModel.team.name ?? "N/A")
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
        .navigationBarTitle(viewModel.team.name ?? "")
    }
}


struct TeamHeader: View {
    
    let team: Team
    
    var body: some View {
        ZStack {
            Color.gray
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
            VStack(alignment: .trailing) {
                HStack {
                    Text(team.abbreviation ?? "N/A")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .bold()
                    Spacer()
                }.padding()
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Text(team.fullName ?? "N/A")
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
    TeamView(viewModel: TeamViewModel(team: MockData.shared.team))
}
