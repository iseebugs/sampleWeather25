//
//  Protocols.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

// MARK: - LocationServiceDelegate

protocol LocationServiceDelegate: AnyObject {
    
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithDefaultLocation()
}

// MARK: - WeatherServiceProtocol

protocol WeatherServiceProtocol {
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void)
    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<ForecastModel, Error>) -> Void)
}
