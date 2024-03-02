//
//  CharacterDetailDetailsTableViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

final class CharacterDetailDetailsTableViewCell: UITableViewCell {
    static let identifier = String(describing: CharacterDetailDetailsTableViewCell.self)
   
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
      
    }
    
    private func setupLayout() {
    
    }
    
    private func setupAppearence() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
    }
    
    public func configure(with model: CharacterDetailDetailsTableViewCellModel) {
        
    }
}
