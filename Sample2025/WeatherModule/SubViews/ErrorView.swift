//
//  ErrorView.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import UIKit

final class WeatherErrorView: UIView {
    
    // MARK: - Public

    var onRetry: (() -> Void)?

    // MARK: - UI Elements

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        layer.cornerRadius = 8
        layer.masksToBounds = true

        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])

        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func didTapRetry() {
        onRetry?()
    }

    // MARK: - Public API

    func setMessage(_ text: String) {
        messageLabel.text = text
    }
}
