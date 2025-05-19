//
//  HourlyForecastProtocols.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

protocol HourlyForecastPresenterProtocol {
    
    func configureView()
}

protocol HourlyForecastView: AnyObject {
    
    func displayTime(_ text: String)
    func displayTemperature(_ text: String)
    func displayIcon(from url: String)
}
