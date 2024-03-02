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
        let gateway = CharacterInfoGatewayImpl()
        let useCase = CharacterDetailsUseCaseImpl(gateway: gateway)
        vc.presenter = CharacterDetailsPresenterImpl(
            view: vc,
            router: router,
            characterDetailsUseCase: useCase,
            characterId: characterId
        )
        
        return vc
    }
}
