//
//  DailyForecastCellPresenter.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

// MARK: - DailyForecastCellPresenter

final class DailyForecastCellPresenter: DailyForecastCellPresenterProtocol {
    
    private let model: DailyForecast

    init(model: DailyForecast) {
        self.model = model
    }

    var dateText: String {
        return model.date // todo: формат
    }

    var temperatureText: String {
        return "\(Int(model.averageTemperature))°"
    }

    var iconURL: String {
        return model.iconURL
    }
}
