//
//  CharacterDetailImageTableViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

final class CharacterDetailImageTableViewCell: UITableViewCell, TableViewDequeueable {
    
    static let identifier = String(describing: CharacterDetailImageTableViewCell.self)
    
    private let characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        return image
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
        contentView.addSubview(characterImage)
    }
    
    private func setupLayout() {
        
        let characterImageConstraints: [NSLayoutConstraint] = [
            characterImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            characterImage.heightAnchor.constraint(equalToConstant: 250),
            characterImage.widthAnchor.constraint(equalToConstant: 250),
            characterImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            characterImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(characterImageConstraints)
        
    }
    
    private func setupAppearence() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func configure(viewModel: TableViewRowViewModelable) {
        guard let model = viewModel as? CharacterDetailImageTableViewCellModel else { return }
        characterImage.image = model.image
    }
}
