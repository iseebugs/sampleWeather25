//
//  Config.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation
import CoreLocation

struct Constants {
    
    struct API {
        
        static let key = "key"
        static let baseURL = "https://api.weatherapi.com/v1/"
    }

    struct Location {
        
        static let fallback = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
    }
}
