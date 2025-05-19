//
//  HourlyForecastCell.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import UIKit

final class HourlyForecastCell: UICollectionViewCell {
    
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    private var presenter: HourlyForecastPresenter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: HourlyForecast) {
        presenter = HourlyForecastPresenter(view: self, model: model)
        presenter?.configureView()
    }
    
    private func setup() {
        self.contentView.backgroundColor = .systemTeal

        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textAlignment = .center
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tempLabel.font = .systemFont(ofSize: 14)
        tempLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        iconImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
}

// MARK: - HourlyForecastView

extension HourlyForecastCell: HourlyForecastView {

    func displayTime(_ text: String) {
        timeLabel.text = text
    }

    func displayTemperature(_ text: String) {
        tempLabel.text = text
    }

    func displayIcon(from url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.iconImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
