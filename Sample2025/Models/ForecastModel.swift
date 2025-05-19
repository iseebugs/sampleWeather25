//
//  ForecastModel.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

struct HourlyForecast {
    let time: String
    let temperature: Double
    let iconURL: String
}

struct DailyForecast {
    let date: String
    let averageTemperature: Double
    let conditionText: String
    let iconURL: String
}

struct ForecastModel {
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
}
