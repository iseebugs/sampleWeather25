//
//  WeatherInteractor.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import Foundation

class WeatherInteractor: WeatherInteractorProtocol {
    weak var presenter: WeatherInteractorOutputProtocol?

    func fetchWeather() {
        // Здесь будет реальный API-запрос, пока заглушка:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.presenter?.didFetchWeather(data: "Sunny, +25°C")
        }
    }
}

