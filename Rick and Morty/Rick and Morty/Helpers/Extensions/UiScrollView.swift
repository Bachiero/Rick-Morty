//
//  UiScrollView.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit.UIScrollView

extension UIScrollView {
    var centerPoint: CGPoint {
        CGPoint(x: self.frame.size.width / 2 + self.contentOffset.x,
                y: self.frame.size.height / 2 + self.contentOffset.y)
    }
}
