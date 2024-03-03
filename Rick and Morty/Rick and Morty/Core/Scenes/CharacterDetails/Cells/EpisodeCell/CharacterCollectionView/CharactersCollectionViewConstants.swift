//
//  CharactersCollectionViewConstants.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

struct CharactersCollectionViewConstants {
    
    struct Dimensions {
        static let collectionViewInsets = UIEdgeInsets(
            top: 8,
            left: (UIScreen.main.bounds.width - collectionViewCellWidth) / 2,
            bottom: 8,
            right: (UIScreen.main.bounds.width - collectionViewCellWidth) / 2)
        static let collectionViewCellWidth = CGFloat(150)
        static let collectionViewCellHeight = CGFloat(150)
        static var collectionViewItemSize: CGSize {
            CGSize(width: collectionViewCellWidth,
                   height: collectionViewCellHeight)
        }
        static let collectionViewSpacing = CGFloat(16)
    }
    
}
