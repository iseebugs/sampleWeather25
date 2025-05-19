//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//
//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//
import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Dependencies
    
    var presenter: WeatherPresenterProtocol?

    // MARK: - UI Elements
    
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
    
    private lazy var errorView: WeatherErrorView = {
        let view = WeatherErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.onRetry = { [weak self] in
            self?.presenter?.viewDidLoad()
        }
        return view
    }()

    private lazy var dailyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 32, height: 60)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

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
        view.addSubview(hourlyCollectionView)
        view.addSubview(dailyCollectionView)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),

            hourlyCollectionView.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 24),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 100),

            dailyCollectionView.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 24),
            dailyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dailyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dailyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            errorView.heightAnchor.constraint(equalToConstant: 60)
        ])
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
}
