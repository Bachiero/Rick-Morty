//
//  CharactersListTableViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import UIKit

final class CharactersListTableViewCell: UITableViewCell {
    static let identifier = String(describing: CharactersListTableViewCell.self)
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        return image
    }()
    
    private let characterName: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.numberOfLines = 0
        title.textColor = Colors.RickDomColorPalette.white
        return title
    }()
    
    private let characterStatus: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = Colors.RickDomColorPalette.white
        return label
    }()
    
    private let characterType: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Colors.RickDomColorPalette.white
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        stack.layer.cornerRadius = 16
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
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
        contentView.addSubview(hStack)
        hStack.addArrangedSubview(image)
        hStack.addArrangedSubview(vStack)
        
        vStack.addArrangedSubview(characterName)
        vStack.addArrangedSubview(characterStatus)
        vStack.addArrangedSubview(characterType)
    }
    
    private func setupLayout() {
        let hStackConstraints: [NSLayoutConstraint] = [
            hStack.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 8),
            hStack.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -8),
            hStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ]
       
        let imageConstraints:  [NSLayoutConstraint] = [
            image.heightAnchor.constraint(equalToConstant: 150),
            image.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(hStackConstraints)
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    private func setupAppearence() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        hStack.backgroundColor = Colors.RickDomColorPalette.darkGrey
        vStack.backgroundColor = .clear
        self.selectionStyle = .none
        
    }
    
    public func configure(with model: CharactersListTableViewCellModel) {
        image.image = model.image
        
        characterName.text = "Name: \(model.characterName)"
        characterName.isHidden = model.characterName.isEmpty
        
        characterStatus.text = "Status: \(model.status)"
        characterStatus.isHidden = model.status.isEmpty
        
        characterType.text = "Type: \(model.type)"
        characterType.isHidden = model.type.isEmpty
    }
    
 
}
