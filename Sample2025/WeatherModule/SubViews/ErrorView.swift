//
//  ErrorView.swift
//  Sample2025
//
//  Created by Macbook on 19.05.2025.
//

import UIKit

// MARK: - WeatherErrorView

final class WeatherErrorView: UIView {

// MARK: - Public

    var onRetry: (() -> Void)?
    
// MARK: - Constants

    private enum Constants {
        static let messageNumberOfLines = 2
        static let messageFontSize: CGFloat = 16
        static let retryButtonTitle = "Повторить"
        static let retryButtonFontSize: CGFloat = 16
        static let cornerRadius: CGFloat = 8
        static let stackSpacing: CGFloat = 8
        static let stackPaddingVertical: CGFloat = 8
        static let stackPaddingHorizontal: CGFloat = 12
        static let backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
    }
    
// MARK: - UI Elements

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constants.messageNumberOfLines
        label.font = .systemFont(ofSize: Constants.messageFontSize)
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.retryButtonTitle, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: Constants.retryButtonFontSize)
        return button
    }()

// MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Setup

    private func setupUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true

        let stack = UIStackView(arrangedSubviews: [messageLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackPaddingVertical),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.stackPaddingVertical),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackPaddingHorizontal),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.stackPaddingHorizontal)
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
