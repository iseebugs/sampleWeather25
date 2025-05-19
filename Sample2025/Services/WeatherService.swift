//
//  WeatherService.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation
import CoreLocation

// MARK: - WeatherService

class WeatherService: WeatherServiceProtocol {

// MARK: - Properties

    private let session = URLSession.shared

// MARK: - Public Methods

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
                if let current = json?[WeatherServiceKeys.current] as? [String: Any],
                   let temp = current[WeatherServiceKeys.tempC] as? Double,
                   let condition = current[WeatherServiceKeys.condition] as? [String: Any],
                   let text = condition[WeatherServiceKeys.text] as? String,
                   let icon = condition[WeatherServiceKeys.icon] as? String,
                   let location = json?[WeatherServiceKeys.location] as? [String: Any],
                   let city = location[WeatherServiceKeys.name] as? String {

                    let weather = WeatherModel(
                        temperature: temp,
                        conditionText: text,
                        iconURL: WeatherServiceConstants.iconPrefix + icon,
                        cityName: city
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
        let urlString = "\(Constants.API.baseURL)forecast.json?key=\(Constants.API.key)&q=\(lat),\(lon)&days=\(WeatherServiceConstants.forecastDays)"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ServiceError.invalidURL))
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(ServiceError.emptyResponse))
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard
                    let forecast = json?[WeatherServiceKeys.forecast] as? [String: Any],
                    let days = forecast[WeatherServiceKeys.forecastday] as? [[String: Any]]
                else {
                    return completion(.failure(ServiceError.invalidFormat))
                }

                var hourly: [HourlyForecast] = []

                for dayIndex in 0..<min(WeatherServiceConstants.forecastDays, days.count) {
                    let day = days[dayIndex]
                    if let hours = day[WeatherServiceKeys.hour] as? [[String: Any]] {
                        for hourData in hours {
                            guard
                                let timeString = hourData[WeatherServiceKeys.time] as? String,
                                let temp = hourData[WeatherServiceKeys.tempC] as? Double,
                                let condition = hourData[WeatherServiceKeys.condition] as? [String: Any],
                                let icon = condition[WeatherServiceKeys.icon] as? String
                            else { continue }

                            let hour = HourlyForecast(
                                time: String(timeString.suffix(5)),
                                temperature: temp,
                                iconURL: WeatherServiceConstants.iconPrefix + icon
                            )

                            hourly.append(hour)
                        }
                    }
                }

                let daily: [DailyForecast] = days.compactMap { dayJSON in
                    guard let dayData = try? JSONSerialization.data(withJSONObject: dayJSON) else { return nil }
                    return try? JSONDecoder().decode(DailyForecast.self, from: dayData)
                }

                let forecastModel = ForecastModel(hourly: hourly, daily: daily)
                completion(.success(forecastModel))

            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - WeatherServiceConstants

private enum WeatherServiceConstants {
    static let forecastDays = 2
    static let iconPrefix = "https:"
}

// MARK: - WeatherServiceKeys

private enum WeatherServiceKeys {
    static let current = "current"
    static let tempC = "temp_c"
    static let condition = "condition"
    static let text = "text"
    static let icon = "icon"
    static let location = "location"
    static let name = "name"

    static let forecast = "forecast"
    static let forecastday = "forecastday"
    static let hour = "hour"
    static let time = "time"
}

