//
//  HourlyForecastModel.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

struct HourlyForecast: Codable {
    let time: String
    let temperature: Double
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temp_c"
        case iconURL = "condition"
    }

    enum ConditionKeys: String, CodingKey {
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(String.self, forKey: .time)
        temperature = try container.decode(Double.self, forKey: .temperature)

        let conditionContainer = try container.nestedContainer(keyedBy: ConditionKeys.self, forKey: .iconURL)
        let icon = try conditionContainer.decode(String.self, forKey: .icon)
        iconURL = "https:\(icon)"
    }

    // 🔧 Добавьте этот инициализатор вручную
    init(time: String, temperature: Double, iconURL: String) {
        self.time = time
        self.temperature = temperature
        self.iconURL = iconURL
    }
}
