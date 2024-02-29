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
        vc.presenter = CharactersListPresenterImpl(view: vc, router: router)
        
        return vc
    }
}
