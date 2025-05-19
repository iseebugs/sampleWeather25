//
//  DailyForecastModel.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

// MARK: - DailyForecast

struct DailyForecast: Decodable {
    
    let date: String
    let averageTemperature: Double
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case date
        case day
    }

    enum DayKeys: String, CodingKey {
        case avgtemp_c
        case condition
    }

    enum ConditionKeys: String, CodingKey {
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)

        let dayContainer = try container.nestedContainer(keyedBy: DayKeys.self, forKey: .day)
        averageTemperature = try dayContainer.decode(Double.self, forKey: .avgtemp_c)

        let conditionContainer = try dayContainer.nestedContainer(keyedBy: ConditionKeys.self, forKey: .condition)
        let iconPath = try conditionContainer.decode(String.self, forKey: .icon)
        iconURL = "https:\(iconPath)"
    }
}
