//
//  ClubViewModel.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import Foundation
import MapKit

final class TeamViewModel: ObservableObject {
    
    var team: Team
    let teamImages = ["person.3.sequence.fill", "person.2.circle.fill", "figure.2"]
    
    @Published var hometownLocation: CLLocationCoordinate2D?
    @Published var hometownRegion: MKCoordinateRegion?
    
    private let locationManager = CLLocationManager()
    
    init(team: Team) {
        self.team = team
        loadTeamCityLocation()
    }
    
    private func loadTeamCityLocation() {
        guard let teamCity = team.city, let conference = team.conference, let division = team.division else {return}
        self.locationManager.getLocation(forPlaceCalled: "\(teamCity), \(division) \(conference), US") { location in
               guard let location = location else { return }
               
               let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
               let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
               self.hometownLocation = center
               self.hometownRegion = region
           }
       }
}
