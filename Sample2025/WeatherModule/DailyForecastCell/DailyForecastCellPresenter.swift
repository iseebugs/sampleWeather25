//
//  DailyForecastCellPresenter.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import Foundation
import UIKit

// MARK: - DailyForecastCellPresenter

final class DailyForecastCellPresenter: DailyForecastCellPresenterProtocol {

// MARK: - Properties

    private let model: DailyForecast

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.inputDateFormat

        guard let date = formatter.date(from: model.date) else {
            return model.date
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = Constants.outputDateFormatPrefix + dateSuffix(for: date) + "'"
        return outputFormatter.string(from: date)
    }

    var temperatureText: String {
        return "\(Int(model.averageTemperature))°"
    }

    var iconURL: String {
        return model.iconURL
    }
    
    // MARK: - Constants

        private enum Constants {
            static let inputDateFormat = "yyyy-MM-dd"
            static let outputDateFormatPrefix = "EEEE d'"
        }

    // MARK: - Init

        init(model: DailyForecast) {
            self.model = model
        }
    
    // MARK: - Private

    private func dateSuffix(for date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)

        switch day {
        case 11, 12, 13:
            return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}
