//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var presenter: WeatherPresenterProtocol?

    private var hourlyData: [HourlyForecast] = [
        HourlyForecast(time: "18:00", temperature: 23.0, iconURL: "https://cdn.weatherapi.com/weather/64x64/day/113.png"),
        HourlyForecast(time: "19:00", temperature: 22.0, iconURL: "https://cdn.weatherapi.com/weather/64x64/day/116.png"),
        HourlyForecast(time: "20:00", temperature: 21.0, iconURL: "https://cdn.weatherapi.com/weather/64x64/night/122.png")
    ]
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "HourlyForecastCell")
        return collectionView
    }()

    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        
        temperatureLabel.font = .systemFont(ofSize: 36, weight: .bold)
        temperatureLabel.textAlignment = .center

        descriptionLabel.font = .systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [temperatureLabel, iconImageView, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        view.addSubview(hourlyCollectionView)

        NSLayoutConstraint.activate([
            hourlyCollectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 100)
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

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCell else {
            return UICollectionViewCell()
        }

        let model = hourlyData[indexPath.item]
        cell.configure(with: model)
        return cell
    }
}

// MARK: - WeatherViewProtocol

extension WeatherViewController: WeatherViewProtocol {
    
  func showWeather(_ model: WeatherModel) {
      temperatureLabel.text = "\(model.temperature)°C"
      descriptionLabel.text = model.conditionText
      loadImage(from: model.iconURL)
  }
    
    func showError(_ message: String) {
         temperatureLabel.text = "Ошибка"
         descriptionLabel.text = message
        print("\(message)")
     }
}
