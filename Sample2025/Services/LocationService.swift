//
//  LocationService.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import CoreLocation

class LocationService: NSObject {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()

        let status = locationManager.authorizationStatus

        if status == .denied || status == .restricted {
            useDefaultLocation()
        } else {
            locationManager.requestLocation()
        }
    }

    private func useDefaultLocation() {
        delegate?.didUpdateLocation(latitude: Constants.defaultLocation.latitude,
                                    longitude: Constants.defaultLocation.longitude)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.didUpdateLocation(latitude: location.coordinate.latitude,
                                        longitude: location.coordinate.longitude)
        } else {
            useDefaultLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        useDefaultLocation()
    }
}
