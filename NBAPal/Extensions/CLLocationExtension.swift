//
//  CLLocationExtension.swift
//  NBAPal
//
//  Created by Roman Auersvald on 17.04.2024.
//

import Foundation
import MapKit

// MARK: - Get Location
extension CLLocationManager {
    
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placemarks, error in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let placemark = placemarks?[0] else {
                completion(nil)
                return
            }
            guard let location = placemark.location else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
}
