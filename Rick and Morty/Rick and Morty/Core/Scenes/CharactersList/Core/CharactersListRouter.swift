//
//  CharactersListRouter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

protocol CharactersListRouter {
    func routeToDetails()
}

final class CharactersListRouterImpl: CharactersListRouter {
    private unowned let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func routeToDetails() {
        
    }
}
