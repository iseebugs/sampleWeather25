//
//  WeatherService.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation
import CoreLocation

class WeatherService: WeatherServiceProtocol {
    
    private let session = URLSession.shared

    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        let urlString = "\(Constants.API.baseURL)current.json?key=\(Constants.API.key)&q=\(lat),\(lon)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ServiceError.invalidURL))
        }

        session.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(ServiceError.emptyResponse))
            }

            do {
                print(String(data: data, encoding: .utf8) ?? "no data")

                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let current = json?["current"] as? [String: Any],
                   let temp = current["temp_c"] as? Double,
                   let condition = current["condition"] as? [String: Any],
                   let text = condition["text"] as? String,
                   let icon = condition["icon"] as? String {

                    let weather = WeatherModel(
                        temperature: temp,
                        conditionText: text,
                        iconURL: "https:\(icon)"
                    )
                    completion(.success(weather))
                } else {
                    completion(.failure(ServiceError.invalidFormat))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchForecast(lat: Double, lon: Double, completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        
        let urlString = "\(Constants.API.baseURL)current.json?key=\(Constants.API.key)&q=\(lat),\(lon)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ServiceError.invalidURL))
        }

        session.dataTask(with: url) { data, response, error in
                                                                            // TODO: парсим forecast → ForecastModel
            completion(.failure(ServiceError.notImplemented)) // пока заглушка
        }.resume()
    }
}
