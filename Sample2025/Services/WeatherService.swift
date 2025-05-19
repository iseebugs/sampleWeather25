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
        let urlString = "\(Constants.API.baseURL)forecast.json?key=\(Constants.API.key)&q=\(lat),\(lon)&days=2"
        guard let url = URL(string: urlString) else {
            return completion(.failure(ServiceError.invalidURL))
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(ServiceError.emptyResponse))
            }
            
//             let string = String(data: data, encoding: .utf8)
//                print("🔵 RAW RESPONSE:")
//                print(string)

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard
                    let forecast = json?["forecast"] as? [String: Any],
                    let days = forecast["forecastday"] as? [[String: Any]]
                else {
                    return completion(.failure(ServiceError.invalidFormat))
                }

                var hourly: [HourlyForecast] = []

                for dayIndex in 0..<min(2, days.count) {
                    let day = days[dayIndex]
                    if let hours = day["hour"] as? [[String: Any]] {
                        for hourData in hours {
                            guard
                                let timeString = hourData["time"] as? String,
                                let temp = hourData["temp_c"] as? Double,
                                let condition = hourData["condition"] as? [String: Any],
                                let icon = condition["icon"] as? String
                            else { continue }

                            let hour = HourlyForecast(
                                time: String(timeString.suffix(5)), // "2025-05-18 21:00" → "21:00"
                                temperature: temp,
                                iconURL: "https:\(icon)"
                            )

                            // фильтрация оставшихся часов ??
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
