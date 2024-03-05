//
//  CharacterDetailsEpisodeTableViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

final class CharacterDetailsEpisodeTableViewCell: UITableViewCell, TableViewDequeueable {
    
    static let identifier = String(describing: CharacterDetailsEpisodeTableViewCell.self)
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = Colors.RickDomColorPalette.darkGrey
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = Colors.RickDomColorPalette.darkGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()
    
    private let charactersCollectionView: CharactersCollectionView = {
        let collectionView = CharactersCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.layer.borderWidth = 1
        separator.backgroundColor = Colors.RickDomColorPalette.darkGrey
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
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
        contentView.addSubview(separator)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(episodeInfoView)
        vStack.addArrangedSubview(charactersCollectionView)
        episodeInfoView.addSubview(nameLabel)
        episodeInfoView.addSubview(dateLabel)
    }
    
    private func setupLayout() {
        let separatorConstraints: [NSLayoutConstraint] = [
            separator.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 1),
            separator.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separator.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ]
        
        let vStackConstraints: [NSLayoutConstraint] = [
            vStack.topAnchor.constraint(equalTo: separator.safeAreaLayoutGuide.bottomAnchor),
            vStack.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            vStack.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let nameConstraints: [NSLayoutConstraint] = [
            nameLabel.leftAnchor.constraint(equalTo: episodeInfoView.leftAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: episodeInfoView.centerYAnchor)
        ]
        
        
        let dateConstraints: [NSLayoutConstraint] = [
            dateLabel.rightAnchor.constraint(equalTo: episodeInfoView.rightAnchor, constant: -8),
            dateLabel.centerYAnchor.constraint(equalTo: episodeInfoView.centerYAnchor)
        ]
        
        charactersCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        episodeInfoView.heightAnchor.constraint(equalToConstant: 30).isActive = true
       
        let constraints = [separatorConstraints, vStackConstraints, nameConstraints, dateConstraints]
        constraints.forEach { NSLayoutConstraint.activate($0) }
    }
    
    private func setupAppearence() {
        backgroundColor = Colors.RickDomColorPalette.white
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func configure(viewModel: TableViewRowViewModelable) {
        guard let model = viewModel as? CharacterDetailsEpisodeTableViewCellModel else { return }
        nameLabel.text = model.episodeName
        dateLabel.text = " \(model.episodeAirDate) ＞"
        charactersCollectionView.configure(withModel: model.characterImages)
        charactersCollectionView.isHidden = !model.isExpanded
        charactersCollectionView.didSelectDelegate = model.didSelectImageDelegate
        charactersCollectionView.accessibilityIdentifier = model.episodeName
    }
}
