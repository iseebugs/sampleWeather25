//
//  WeatherInteractor.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

final class WeatherInteractor: WeatherInteractorProtocol {

// MARK: - Dependencies
    
    weak var presenter: WeatherInteractorOutputProtocol?
    private let locationService = LocationService()
    private let weatherService: WeatherServiceProtocol = WeatherService()

// MARK: - Init
    
    init() {
        locationService.delegate = self
    }

// MARK: - WeatherInteractorProtocol
    
    func fetchWeather() {
        locationService.requestLocation()
    }
}

// MARK: - LocationServiceDelegate

extension WeatherInteractor: LocationServiceDelegate {

    func didUpdateLocation(latitude: Double, longitude: Double) {
        weatherService.fetchCurrentWeather(lat: latitude, lon: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.presenter?.didFetchWeather(model: model)
                case .failure(let error):
                    self?.presenter?.didFailToFetchWeather(error: error.localizedDescription)
                }
            }
        }

        weatherService.fetchForecast(lat: latitude, lon: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self?.presenter?.didFetchForecast(forecast)
                case .failure(let error):
                    // TODO: показать окошко
                    print("Forecast error: \(error.localizedDescription)")
                }
            }
        }
    }

    func didFailWithDefaultLocation() {
        let fallback = Constants.Location.fallback
        didUpdateLocation(latitude: fallback.latitude, longitude: fallback.longitude)
    }
}
