//
//  HourlyForecastCell.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//
import UIKit

final class HourlyForecastCell: UICollectionViewCell {

// MARK: - UI Elements
    
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()
    private let spacerBottom = UIView()
    private var gradientLayer: CAGradientLayer?
    
// MARK: - Constants
    
    struct HourlyForecastCell {
        static let fontSize: CGFloat = 17
        static let iconSize: CGFloat = 65
        static let cornerRadius: CGFloat = 12
        static let stackSpacing: CGFloat = -5
        static let spacierHeight: CGFloat = 46
        static let gradientColors: [CGColor] = [
            UIColor(white: 1.0, alpha: 0.3).cgColor,
            UIColor(white: 0.8, alpha: 0.3).cgColor
        ]
        static let gradientStart = CGPoint(x: 0, y: 0)
        static let gradientEnd = CGPoint(x: 1, y: 1)
    }
    
// MARK: - Properties
    
    private var presenter: HourlyForecastPresenter?
    
// MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = contentView.bounds
    }

// MARK: - Configuration

    func configure(with model: HourlyForecast) {
        presenter = HourlyForecastPresenter(view: self, model: model)
        presenter?.configureView()
    }

// MARK: - Private

    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = HourlyForecastCell.cornerRadius
        contentView.clipsToBounds = true

        timeLabel.font = .systemFont(ofSize: HourlyForecastCell.fontSize)
        timeLabel.textAlignment = .center

        tempLabel.font = .systemFont(ofSize: HourlyForecastCell.fontSize)
        tempLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = HourlyForecastCell.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: HourlyForecastCell.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: HourlyForecastCell.iconSize)
        ])

        applyGradientBackground()
    }

    private func applyGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = HourlyForecastCell.gradientColors
        gradient.startPoint = HourlyForecastCell.gradientStart
        gradient.endPoint = HourlyForecastCell.gradientEnd
        gradient.frame = contentView.bounds
        gradient.cornerRadius = HourlyForecastCell.cornerRadius

        contentView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
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
