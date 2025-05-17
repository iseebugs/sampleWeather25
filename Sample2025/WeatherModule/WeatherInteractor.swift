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
    private let weatherService = WeatherService()

    init() {
        locationService.delegate = self
    }

    func fetchWeather() {
        locationService.requestLocation()
    }
}

extension WeatherInteractor: LocationServiceDelegate {
    
    func didUpdateLocation(latitude: Double, longitude: Double) {
        weatherService.fetchCurrentWeather(lat: latitude, lon: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.presenter?.didFetchWeather(data: "\(weather.conditionText), \(weather.temperature)°C")
                case .failure(let error):
                    self?.presenter?.didFailToFetchWeather(error: error.localizedDescription)
                }
            }
        }
    }

    func didFailWithDefaultLocation() {
        presenter?.didFailToFetchWeather(error: "Location access denied, using fallback.")
    }
}
