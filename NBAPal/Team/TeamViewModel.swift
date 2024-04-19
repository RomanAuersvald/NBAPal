//
//  ClubViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import MapKit
import OSLog

@MainActor
final class TeamViewModel: ObservableObject {
    
    var team: Team
    let teamImages = ["person.3.sequence.fill", "person.2.circle.fill", "figure.2"]
    
    // present if it is possible to geocode team's city
    @Published var hometownLocation: CLLocationCoordinate2D?
    @Published var hometownRegion: MKCoordinateRegion?
    
    private let locationManager = CLLocationManager()
    
    init(team: Team) {
        self.team = team
        loadTeamCityLocation()
    }
    
    private func loadTeamCityLocation() {
        guard let teamCity = team.city else {
            Logger.userInteraction.warning("Team city location failed. No hometown city.")
            return
        }
        Logger.userInteraction.log("Loading \(teamCity) location")
        self.locationManager.getLocation(forPlaceCalled: "\(teamCity), US") { location in
            guard let location = location else {
                Logger.userInteraction.warning("Failed to reverse geocode \(teamCity)")
                return
            }
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.hometownLocation = center
            self.hometownRegion = region
        }
    }
}

