//
//  ForecastModel.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

struct ForecastModel {
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
    let hour: [HourlyForecast] // если нужен почасовой прогноз
}

struct Day: Codable {
    let avgtemp_c: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}
