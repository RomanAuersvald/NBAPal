//
//  ClubView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import Combine
import MapKit

struct TeamView: View {
    
    @StateObject var viewModel: TeamViewModel
    
    var body: some View {
        ScrollView {
            TeamHeader(team: viewModel.team, teamImages: viewModel.teamImages)
            
            ZStack {
                VStack {
                    VStack {
                        Spacer()
                        HStack {
                            Text(viewModel.team.fullName ?? "N/A")
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                        }.padding(5)
                        Spacer(minLength: 20)
                    }
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
                    Spacer(minLength: 20)
                    Text("Home Town")
                        .textCase(.uppercase)
                        .bold()
                    Spacer(minLength: 20)
                    if let location = viewModel.hometownLocation, let region = viewModel.hometownRegion {
                        Map(initialPosition: MapCameraPosition.region(region)) {
                            Marker(coordinate: location) {
                                Text("\(viewModel.team.city!)")
                            }
                            
                        }
                        .mapStyle(.standard)
                        .frame(minHeight: 220, maxHeight: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    }
                }
            }
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
    let teamImages: [String]
    
    var body: some View {
        ZStack {
            PageGallery(images: teamImages)
                .frame(minHeight: 220)
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
        }
        .frame(minHeight: 200, maxHeight: 250)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    TeamView(viewModel: TeamViewModel(team: MockData.shared.team))
}
