//
//  CharactersListConfigurator.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

struct CharactersListConfigurator {
    func configured() -> UIViewController {
        let vc = CharactersListViewController()
        let router = CharactersListRouterImpl(controller: vc)
        let gateway = CharactersListGatewayImpl()
        let useCase = CharactersListUseCaseImpl(gateway: gateway)
        
        vc.presenter = CharactersListPresenterImpl(
            view: vc,
            router: router,
            charactersListUseCase: useCase
        )
        
        return vc
    }
}
