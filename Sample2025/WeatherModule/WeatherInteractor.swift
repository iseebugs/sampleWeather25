//
//  WeatherInteractor.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

class WeatherInteractor: WeatherInteractorProtocol {
    
    weak var presenter: WeatherInteractorOutputProtocol?
    private let locationService = LocationService()

    init() {
        locationService.delegate = self
    }

    func fetchWeather() {
        locationService.requestLocation()
    }
}

extension WeatherInteractor: LocationServiceDelegate {
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
                                                                                            // TODO: сделать запрос погоды по координатам
        print("🌍🌍🌍 Location: \(latitude), \(longitude)")
        presenter?.didFetchWeather(data: "Weather for lat \(latitude), lon \(longitude)")
    }

    func didFailWithDefaultLocation() {
        presenter?.didFailToFetchWeather(error: "Location access denied, using fallback.")
    }
}
