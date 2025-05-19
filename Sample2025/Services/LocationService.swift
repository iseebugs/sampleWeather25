//
//  LocationService.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import CoreLocation

// MARK: - LocationService

class LocationService: NSObject {

// MARK: Properties

    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?

// MARK: Initialization

    override init() {
        super.init()
        locationManager.delegate = self
    }

// MARK: Public Methods

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()

        let status = locationManager.authorizationStatus

        if status == .denied || status == .restricted {
            useDefaultLocation()
        } else {
            locationManager.requestLocation()
        }
    }

// MARK: Private Methods

    private func useDefaultLocation() {
        delegate?.didUpdateLocation(latitude: Constants.Location.fallback.latitude,
                                    longitude: Constants.Location.fallback.longitude)
    }
}

// MARK: - CLLocationManagerDelegate

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
