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
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let characterName: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 18, weight: .medium)
        title.numberOfLines = 0
        return title
    }()
    
    private let characterStatus: UILabel = {
        let author = UILabel()
        author.translatesAutoresizingMaskIntoConstraints = false
        author.font = .systemFont(ofSize: 14, weight: .regular)
        author.numberOfLines = 0
        return author
    }()
    
    private let characterType: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
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
        NSLayoutConstraint.activate(hStackConstraints)
        
        //FIXME: Fix constraints for image + texts. adjust alignment
    }
    
    private func setupAppearence() {
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
    }
    
    public func configure(with model: CharactersListTableViewCellModel) {
        //FIXME: add texts to values. (name - name, status - status, type - type)
        image.image = model.image
        characterName.text = model.characterName
        characterStatus.text = model.status
        characterType.text = model.type
    }
}
