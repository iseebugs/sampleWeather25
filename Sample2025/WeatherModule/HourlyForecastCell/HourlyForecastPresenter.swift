//
//  HourlyForecastCellPresenter.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

final class HourlyForecastPresenter: HourlyForecastPresenterProtocol {
    
    private weak var view: HourlyForecastView?
    private let model: HourlyForecast

    init(view: HourlyForecastView, model: HourlyForecast) {
        self.view = view
        self.model = model
    }

    func configureView() {
        view?.displayTime(model.time)
        view?.displayTemperature("\(Int(model.temperature))°")
        view?.displayIcon(from: model.iconURL)
    }
}
