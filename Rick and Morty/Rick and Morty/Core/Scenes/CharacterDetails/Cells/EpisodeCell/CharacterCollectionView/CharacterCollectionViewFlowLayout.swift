//
//  CharacterCollectionViewFlowLayout.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

class CharacterCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let cellWidth: CGFloat
    
    init(cellWidth: CGFloat) {
        self.cellWidth = cellWidth
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Prevents over-scrolling of the item
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment:CGFloat = CGFloat(MAXFLOAT)
        let collectionViewWidth = self.collectionView?.frame.width ?? 0
        let horizontalOffest:CGFloat = proposedContentOffset.x + ( collectionViewWidth - cellWidth ) / 2
        let targetRect = CGRect(x:proposedContentOffset.x,
                                y:0,
                                width:self.collectionView!.bounds.size.width,
                                height:self.collectionView!.bounds.size.height)
        
        let array = super.layoutAttributesForElements(in: targetRect)
        
        for layoutAttributes in array! {
            let itemOffset = layoutAttributes.frame.origin.x
            if abs(itemOffset - horizontalOffest) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffest
            }
        }
        
        return CGPoint(x:proposedContentOffset.x + offsetAdjustment, y:proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

