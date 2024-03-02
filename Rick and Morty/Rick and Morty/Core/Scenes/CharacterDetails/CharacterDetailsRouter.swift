//
//  CharacterDetailsRouter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

protocol CharacterDetailsRouter {

}

final class CharacterDetailsRouterImpl: CharacterDetailsRouter {
    private unowned let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }

}
