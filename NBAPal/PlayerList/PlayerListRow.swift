//
//  PlayerListRow.swift
//  NBAPal
//
//  Created by Roman Auersvald on 16.04.2024.
//

import SwiftUI

struct PlayerListRow: View {
    let player: Player
    var body: some View {
        HStack (spacing: 5) {
            ZStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                .clipShape(Circle())
                Text("\(player.id ?? -1)")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                    .offset(x: -25, y: 25)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(player.firstName ?? "")
                        .font(.headline)
                        .minimumScaleFactor(0.6)
                    Text(player.lastName ?? "")
                        .font(.headline)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                }
                HStack {
                    Text(player.team?.fullName ?? "")
                        .font(.subheadline)
                    Spacer()
                }
            }
            Text(player.position ?? "")
                .font(.title)
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .tint(.gray)
                .padding(.init(top: 0, leading: 5, bottom: 0, trailing: -30))
        }
        .padding(4)
        
    }
}

#Preview {
    List {
        PlayerListRow(player: MockData.shared.player)
    }
}
