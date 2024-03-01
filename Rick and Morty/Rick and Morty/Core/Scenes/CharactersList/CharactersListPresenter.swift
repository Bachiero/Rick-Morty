//
//  CharactersListPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

protocol CharactersListPresenter {
    func initialSetup()
}

final class CharactersListPresenterImpl: CharactersListPresenter {
   
    
    private unowned let view: CharactersListView
    private let router: CharactersListRouter
    
    let charactersListUseCase: CharactersListUseCase
    
    init(
        view: CharactersListView,
        router: CharactersListRouter,
        charactersListUseCase: CharactersListUseCase
    ) {
        self.view = view
        self.router = router
        self.charactersListUseCase = charactersListUseCase
    }
    
    func initialSetup() {
        let request = Request(
            endpoint: .character,
            queryParameters: [URLQueryItem(name: "name", value: "Rick"),
                              URLQueryItem(name: "status", value: "alive")]
        )
        
        charactersListUseCase.getCharactersList(with: request) { response in
            switch response {
            case .success(let entity):
                let entity = entity
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
