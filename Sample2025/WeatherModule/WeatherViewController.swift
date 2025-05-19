//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

// MARK: - WeatherViewController

final class WeatherViewController: UIViewController {

// MARK: - Dependencies

    var presenter: WeatherPresenterProtocol?
    
// MARK: - Constants

    private enum Constants {
        static let hourlyItemSize = CGSize(width: 80, height: 100)
        static let dailyItemHeight: CGFloat = 60
        static let collectionSpacing: CGFloat = 8
        static let cityFont = UIFont.systemFont(ofSize: 24, weight: .medium)
        static let temperatureFont = UIFont.systemFont(ofSize: 36, weight: .bold)
        static let descriptionFont = UIFont.systemFont(ofSize: 20)
        static let iconSize: CGFloat = 64
        static let stackSpacing: CGFloat = 12
        static let topInset: CGFloat = 24
        static let sectionSpacing: CGFloat = 24
        static let sideInset: CGFloat = 16
        static let bottomInset: CGFloat = 24
        static let errorHeight: CGFloat = 60
        static let dailyHorizontalPadding: CGFloat = 16
        static let hourlyCollectionHeight: CGFloat = 100
    }


// MARK: - UI Elements

    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.hourlyItemSize
        layout.minimumInteritemSpacing = Constants.collectionSpacing
        layout.minimumLineSpacing = Constants.collectionSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "HourlyForecastCell")
        return collectionView
    }()

    private lazy var errorView: WeatherErrorView = {
        let view = WeatherErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.onRetry = { [weak self] in
            self?.presenter?.viewDidLoad()
        }
        return view
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.cityFont
        label.textAlignment = .center
        return label
    }()

    private lazy var dailyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - Constants.dailyHorizontalPadding * 2, height: Constants.dailyItemHeight)
        layout.minimumInteritemSpacing = Constants.collectionSpacing
        layout.minimumLineSpacing = Constants.collectionSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DailyForecastCell.self, forCellWithReuseIdentifier: "DailyForecastCell")
        return collectionView
    }()

    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView()

// MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        presenter?.viewDidLoad()
    }

// MARK: - Setup

    private func setupUI() {
        temperatureLabel.font = Constants.temperatureFont
        temperatureLabel.textAlignment = .center

        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel, iconImageView, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyCollectionView)
        view.addSubview(errorView)
        dailyCollectionView.alwaysBounceVertical = true

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topInset),
            iconImageView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Constants.iconSize),

            hourlyCollectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: Constants.sectionSpacing),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: Constants.hourlyCollectionHeight),

            dailyCollectionView.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: Constants.sectionSpacing),
            dailyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            dailyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            dailyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.bottomInset),

            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideInset),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideInset),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.bottomInset),
            errorView.heightAnchor.constraint(equalToConstant: Constants.errorHeight)
        ])

        setupGradientBackground()
    }

// MARK: - Helpers

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.iconImageView.image = UIImage(data: data)
            }
        }.resume()
    }

    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemYellow.cgColor,
            UIColor.systemBlue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = view.bounds

        let backgroundView = UIView(frame: view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundView, at: 0)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return presenter?.numberOfHourlyItems() ?? 0
        } else {
            return presenter?.numberOfDailyItems() ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCell,
                  let model = presenter?.hourlyItem(at: indexPath.item) else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCell", for: indexPath) as? DailyForecastCell,
                  let cellPresenter = presenter?.dailyPresenter(at: indexPath.item) else {
                return UICollectionViewCell()
            }
            cell.configure(with: cellPresenter)
            return cell
        }
    }
}

// MARK: - WeatherViewProtocol

extension WeatherViewController: WeatherViewProtocol {
    func updateMainWeatherInfo(temperature: String, description: String, iconURL: String) {
        temperatureLabel.text = temperature
        descriptionLabel.text = description
        loadImage(from: iconURL)
    }

    func reloadHourlyForecast() {
        hourlyCollectionView.reloadData()
    }

    func reloadDailyForecast() {
        dailyCollectionView.reloadData()
    }

    func showError(_ message: String) {
        errorView.isHidden = false
        errorView.setMessage(message)
    }

    func hideError() {
        errorView.isHidden = true
    }

    func updateCityName(_ name: String) {
        cityLabel.text = name
    }
}
