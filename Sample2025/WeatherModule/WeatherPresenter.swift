//
//  WeatherPresenter.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

// MARK: - WeatherPresenterProtocol

class WeatherPresenter: WeatherPresenterProtocol {
    
    weak var view: WeatherViewProtocol?
    var interactor: WeatherInteractorProtocol?
    var router: WeatherRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchWeather()
    }
}

// MARK: - WeatherInteractorOutputProtocol

extension WeatherPresenter: WeatherInteractorOutputProtocol {
    
    func didFetchWeather(model: WeatherModel) {
        view?.showWeather(model)
    }

    func didFailToFetchWeather(error: String) {
        view?.showError(error)
    }
}
