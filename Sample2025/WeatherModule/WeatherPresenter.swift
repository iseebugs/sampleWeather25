//
//  WeatherPresenter.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

final class WeatherPresenter: WeatherPresenterProtocol {
    
// MARK: - Dependencies
    
    weak var view: WeatherViewProtocol?
    var interactor: WeatherInteractorProtocol?
    var router: WeatherRouterProtocol?
    
// MARK: - State
    
    private var currentWeather: WeatherModel?
    private var hourlyForecast: [HourlyForecast] = []
    private var dailyForecastPresenters: [DailyForecastCellPresenterProtocol] = []
    
// MARK: - WeatherPresenterProtocol
    
    func viewDidLoad() {
        interactor?.fetchWeather()
    }
    
    func numberOfHourlyItems() -> Int {
        return hourlyForecast.count
    }
    
    func hourlyItem(at index: Int) -> HourlyForecast {
        return hourlyForecast[index]
    }
    
    func numberOfDailyItems() -> Int {
        return dailyForecastPresenters.count
    }
    
    func dailyPresenter(at index: Int) -> DailyForecastCellPresenterProtocol {
        return dailyForecastPresenters[index]
    }
}

// MARK: - WeatherInteractorOutputProtocol

extension WeatherPresenter: WeatherInteractorOutputProtocol {
    
    func didFetchWeather(model: WeatherModel) {
        currentWeather = model
        view?.hideError()
        view?.updateMainWeatherInfo(
            temperature: "\(Int(model.temperature))°C",
            description: model.conditionText,
            iconURL: model.iconURL
        )
        view?.updateCityName(model.cityName)
    }
    
    func didFetchForecast(_ forecast: ForecastModel) {
        hourlyForecast = forecast.hourly
        dailyForecastPresenters = forecast.daily.map { DailyForecastCellPresenter(model: $0) }
        view?.hideError()
        view?.reloadHourlyForecast()
        view?.reloadDailyForecast()
    }
    
    
    func didFailToFetchWeather(error: String) {
        view?.showError(error)
    }
}
