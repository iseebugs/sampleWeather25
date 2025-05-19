//
//  DailyForecastCell.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import UIKit

// MARK: - Constants

private enum DailyForecastCellConstants {
    static let fontSize: CGFloat = 16
    static let spacing: CGFloat = 12
    static let iconSize: CGFloat = 52
    static let cornerRadius: CGFloat = 12
    static let horizontalInset: CGFloat = 8
    static let gradientStartAlpha: CGFloat = 0.4
    static let gradientEndAlpha: CGFloat = 0.4
    static let gradientStartWhite: CGFloat = 0.3
    static let gradientEndWhite: CGFloat = 0.0
    static let gradientName = "gradientBackground"
}

// MARK: - DailyForecastCell

final class DailyForecastCell: UICollectionViewCell {

// MARK: - UI Elements

    private let dateLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()

// MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = DailyForecastCellConstants.cornerRadius
        contentView.clipsToBounds = true

        if let gradient = contentView.layer.sublayers?.first(where: { $0.name == DailyForecastCellConstants.gradientName }) {
            gradient.frame = bounds
        }
    }

// MARK: - Configuration

    func configure(with presenter: DailyForecastCellPresenterProtocol?) {
        guard let presenter = presenter else { return }
        dateLabel.text = presenter.dateText
        tempLabel.text = presenter.temperatureText
        loadImage(from: presenter.iconURL)
    }

// MARK: - Private

    private func setupUI() {
        dateLabel.font = .systemFont(ofSize: DailyForecastCellConstants.fontSize, weight: .medium)
        dateLabel.textColor = .white

        tempLabel.font = .systemFont(ofSize: DailyForecastCellConstants.fontSize, weight: .medium)
        tempLabel.textColor = .white

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [dateLabel, iconImageView, tempLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = DailyForecastCellConstants.spacing
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hStack)
        contentView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DailyForecastCellConstants.horizontalInset),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DailyForecastCellConstants.horizontalInset),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: DailyForecastCellConstants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: DailyForecastCellConstants.iconSize)
        ])

        addGradientBackground()
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.iconImageView.image = UIImage(data: data)
            }
        }.resume()
    }

// MARK: - Gradient Background

    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: DailyForecastCellConstants.gradientStartWhite, alpha: DailyForecastCellConstants.gradientStartAlpha).cgColor,
            UIColor(white: DailyForecastCellConstants.gradientEndWhite, alpha: DailyForecastCellConstants.gradientEndAlpha).cgColor
        ]
        self.alpha = 1.0
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = DailyForecastCellConstants.cornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.name = DailyForecastCellConstants.gradientName

        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

