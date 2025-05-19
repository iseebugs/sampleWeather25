//
//  WeatherModuleProtocols.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

// MARK: - View

protocol WeatherViewProtocol: AnyObject {
    
    func updateMainWeatherInfo(temperature: String, description: String, iconURL: String)
    func reloadHourlyForecast()
    func reloadDailyForecast()
    func showError(_ message: String)
    func hideError()
    func updateCityName(_ name: String)
}

// MARK: - WeatherPresenterProtocol

protocol WeatherPresenterProtocol: AnyObject {
    
    func viewDidLoad()

    func numberOfHourlyItems() -> Int
    func hourlyItem(at index: Int) -> HourlyForecast

    func numberOfDailyItems() -> Int
    func dailyPresenter(at index: Int) -> DailyForecastCellPresenterProtocol
}


// MARK: - Interactor

protocol WeatherInteractorProtocol: AnyObject {
    
    func fetchWeather()
}

// MARK: - Interactor Output

protocol WeatherInteractorOutputProtocol: AnyObject {
    
    func didFetchWeather(model: WeatherModel)
    func didFetchForecast(_ forecast: ForecastModel)
    func didFailToFetchWeather(error: String)
}

// MARK: - Router

protocol WeatherRouterProtocol: AnyObject {
    
    static func createModule() -> UIViewController
}
