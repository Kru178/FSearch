//
//  EmptyStateView.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 06.08.2023.
//

import UIKit

final class EmptyStateView: UIView {
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        return stack
    }()
    private let messageLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = Constants.Images.emptyViewImage
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String, withImage: Bool) {
        self.init(frame: .zero)
        messageLabel.text = message
        logoImageView.image = withImage ? Constants.Images.emptyViewImage : nil
    }
    
    private func configureViews() {
        addSubviews(stack)
        stack.addArrangedSubviews(views: messageLabel, logoImageView)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            messageLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}
