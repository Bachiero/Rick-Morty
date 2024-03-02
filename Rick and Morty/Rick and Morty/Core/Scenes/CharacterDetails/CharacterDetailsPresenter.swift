//
//  CharacterDetailsPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

protocol CharacterDetailsPresenter {
    
}

final class CharacterDetailsPresenterImpl: CharacterDetailsPresenter {
    private unowned let view: CharacterDetailsView
    private let router: CharacterDetailsRouter
    private let characterId: Int
    
    init(view: CharacterDetailsView,
         router: CharacterDetailsRouter,
         characterId: Int
    ) {
        self.view = view
        self.router = router
        self.characterId = characterId
    }
}
