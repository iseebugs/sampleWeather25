//
//  WeatherModuleProtocols.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

protocol WeatherViewProtocol: AnyObject {
    
    func showError(_ message: String)
    func showWeather(_ model: WeatherModel)
    func showHourlyForecast(_ forecast: [HourlyForecast])
}

protocol WeatherPresenterProtocol: AnyObject {
    
    func viewDidLoad()
    func didFetchForecast(_ forecast: ForecastModel)
}

protocol WeatherInteractorProtocol: AnyObject {
    
    func fetchWeather()
}

protocol WeatherRouterProtocol: AnyObject {
    
    static func createModule() -> UIViewController
}

protocol WeatherInteractorOutputProtocol: AnyObject {
    
    func didFetchWeather(model: WeatherModel)
    func didFailToFetchWeather(error: String)
    func didFetchForecast(_ forecast: ForecastModel)
}
