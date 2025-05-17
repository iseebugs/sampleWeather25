//
//  WeatherPresenter.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

class WeatherPresenter: WeatherPresenterProtocol {
    
    weak var view: WeatherViewProtocol?
    var interactor: WeatherInteractorProtocol?
    var router: WeatherRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchWeather()
    }
}

extension WeatherPresenter: WeatherInteractorOutputProtocol {
    
    func didFetchWeather(data: String) {
        view?.showWeatherModel(data)
    }

    func didFailToFetchWeather(error: String) {
        view?.showError(error)
    }
}
