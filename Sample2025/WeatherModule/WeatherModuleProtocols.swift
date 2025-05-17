//
//  WeatherModuleProtocols.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

protocol WeatherViewProtocol: AnyObject {
    
    func showWeatherData(_ data: String)
    func showError(_ message: String)
}

protocol WeatherPresenterProtocol: AnyObject {
    
    func viewDidLoad()
}

protocol WeatherInteractorProtocol: AnyObject {
    
    func fetchWeather()
}

protocol WeatherRouterProtocol: AnyObject {
    
    static func createModule() -> UIViewController
}

protocol WeatherInteractorOutputProtocol: AnyObject {
    
    func didFetchWeather(data: String)
    func didFailToFetchWeather(error: String)
}
