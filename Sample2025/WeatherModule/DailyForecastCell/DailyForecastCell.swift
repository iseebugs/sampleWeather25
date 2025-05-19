//
//  DailyForecastCell.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import UIKit

final class DailyForecastCell: UICollectionViewCell {
    
    private let dateLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with presenter: DailyForecastCellPresenterProtocol?) {
        guard let presenter = presenter else { return }
        dateLabel.text = presenter.dateText
        tempLabel.text = presenter.temperatureText
        loadImage(from: presenter.iconURL)
    }

    private func setup() {
        self.contentView.backgroundColor = .systemPink
        dateLabel.font = .systemFont(ofSize: 16)
        tempLabel.font = .systemFont(ofSize: 16)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [dateLabel, iconImageView, tempLabel])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
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
}
