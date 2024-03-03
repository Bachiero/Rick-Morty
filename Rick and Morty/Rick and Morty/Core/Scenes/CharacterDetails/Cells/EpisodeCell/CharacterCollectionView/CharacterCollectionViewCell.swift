//
//  CharacterCollectionViewCell.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit.UIImage

class CharacterCollectionViewCell: UICollectionViewCell {
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    @available( * ,unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        configureHierarchy()
        configureConstraints()
    }
    
    private func configureHierarchy() {
        self.addSubview(image)
    }
    
    private func configureConstraints() {
        let imageConstraints: [NSLayoutConstraint] = [
            image.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            image.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(imageConstraints)
    }
    
    func configure(with image: UIImage) {
        self.image.image = image
    }
}
