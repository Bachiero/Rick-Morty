//
//  CharacterDetailDetailsTableViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

final class CharacterDetailDetailsTableViewCell: UITableViewCell, TableViewDequeueable {
    static let identifier = String(describing: CharacterDetailDetailsTableViewCell.self)
    
    private let detailsTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.numberOfLines = 0
        title.textColor = Colors.RickDomColorPalette.white
        title.text = "Info"
        return title
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.layer.cornerRadius = 16
        stack.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: .zero)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupHierarchy()
        setupLayout()
        setupAppearence()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(detailsTitle)
        contentView.addSubview(detailsStack)
    }
    
    private func setupLayout() {
        let detailsTitleConstraints: [NSLayoutConstraint] = [
            detailsTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            detailsTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8)
        ]
       
        let detailsStackConstraints:  [NSLayoutConstraint] = [
            detailsStack.topAnchor.constraint(equalTo: detailsTitle.bottomAnchor, constant: 8),
            detailsStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            detailsStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(detailsTitleConstraints)
        NSLayoutConstraint.activate(detailsStackConstraints)
    }
    
    private func setupAppearence() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        detailsStack.backgroundColor = Colors.RickDomColorPalette.darkGrey
    }
    
    private func setupDetailsStack(with details: [String]) {
        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        details.forEach {
            let label = getDetailsLabel()
            label.text = $0
            detailsStack.addArrangedSubview(label)
        }
    }
    
    private func getDetailsLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        label.alpha = 1
        return label
    }
    
    func configure(viewModel: TableViewRowViewModelable) {
        guard let model = viewModel as? CharacterDetailDetailsTableViewCellModel else { return }
        setupDetailsStack(with: model.details)
    }
}
