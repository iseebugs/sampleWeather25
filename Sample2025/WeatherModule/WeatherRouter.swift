//
//  WeatherRouter.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

class WeatherRouter: WeatherRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = WeatherViewController()
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        let router = WeatherRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }
}
