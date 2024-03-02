//
//  CharacterDetailsConfigurator.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

struct CharacterDetailsConfigurator {
    func configured(characterId: Int) -> UIViewController {
        let vc = CharacterDetailsViewController()
        let router = CharacterDetailsRouterImpl(controller: vc)
        
        vc.presenter = CharacterDetailsPresenterImpl(
            view: vc,
            router: router,
            characterId: characterId
        )
        
        return vc
    }
}
