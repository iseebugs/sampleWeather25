//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

class WeatherViewController: UIViewController, WeatherViewProtocol {
    
    var presenter: WeatherPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter?.viewDidLoad()
    }

    func showWeatherData(_ data: String) {
        // Показать данные
        print("Weather data: \(data)")
    }

    func showError(_ message: String) {
        // Показать ошибку
        print("Error: \(message)")
    }
}
