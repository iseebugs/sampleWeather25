//
//  HourlyForecastCellPresenter.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import Foundation

// MARK: - HourlyForecastPresenter

final class HourlyForecastPresenter: HourlyForecastPresenterProtocol {

// MARK: - Properties

    private weak var view: HourlyForecastView?
    private let model: HourlyForecast
    
// MARK: - Constants

    private enum Constants {
        static let temperatureSuffix = "°"
    }

// MARK: - Init

    init(view: HourlyForecastView, model: HourlyForecast) {
        self.view = view
        self.model = model
    }

// MARK: - HourlyForecastPresenterProtocol

    func configureView() {
        view?.displayTime(model.time)
        view?.displayTemperature("\(Int(model.temperature))\(Constants.temperatureSuffix)")
        view?.displayIcon(from: model.iconURL)
    }
}
