//
//  DailyForecastProtocols.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

// MARK: - DailyForecastCellPresenterProtocol

protocol DailyForecastCellPresenterProtocol {
    var dateText: String { get }
    var temperatureText: String { get }
    var iconURL: String { get }
}

