//
//  ViewController.swift
//  Sample2025
//
//  Created by Macbook on 17.05.2025.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var presenter: WeatherPresenterProtocol?

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
