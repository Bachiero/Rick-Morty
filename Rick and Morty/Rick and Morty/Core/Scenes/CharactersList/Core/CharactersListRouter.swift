//
//  CharactersListRouter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

protocol CharactersListRouter {
    func routeToDetails(characterId: Int)
}

final class CharactersListRouterImpl: CharactersListRouter {
    private weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func routeToDetails(characterId: Int) {
        let vc = CharacterDetailsConfigurator().configured(characterId: characterId)
        controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
