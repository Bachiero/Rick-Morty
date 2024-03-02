//
//  ErrorMessageView.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 02.03.24.
//

import UIKit

final class ErrorMessageView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setupHierarchy()
        setupConstraints()
        setupAppearence()
    }
    
    private func setupHierarchy() {
        addSubview(label)
    }
    
    private func setupAppearence() {
        layer.cornerRadius = 16
        backgroundColor = .white
    }
    
    private func setupConstraints() {
        
        let viewConstraints: [NSLayoutConstraint] = [
            heightAnchor.constraint(equalToConstant: 80),
            widthAnchor.constraint(equalToConstant: 300),
        ]
        
        let labelConstraints: [NSLayoutConstraint] = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
      
        NSLayoutConstraint.activate(viewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    func configure(withMessage text: String) {
        label.text = text
    }
}
