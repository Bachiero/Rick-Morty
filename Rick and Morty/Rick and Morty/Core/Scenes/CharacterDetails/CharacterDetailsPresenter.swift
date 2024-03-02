//
//  CharacterDetailsPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

protocol CharacterDetailsPresenter {
    func viewDidLoad()
}

final class CharacterDetailsPresenterImpl: CharacterDetailsPresenter {
    private unowned let view: CharacterDetailsView
    private let router: CharacterDetailsRouter
    private let characterId: Int
    private let characterDetailsUseCase: CharacterDetailsUseCase
    
    init(view: CharacterDetailsView,
         router: CharacterDetailsRouter,
         characterDetailsUseCase: CharacterDetailsUseCase,
         characterId: Int
    ) {
        self.view = view
        self.router = router
        self.characterId = characterId
        self.characterDetailsUseCase = characterDetailsUseCase
    }
    
    func viewDidLoad() {
        fetchCharacterDetails(with: characterId)
    }
    
    private func fetchCharacterDetails(with id: Int) {
        let request = Request(endpoint: .character, pathComponents: [String(id)])
        
        characterDetailsUseCase.getCharacterDetails(with: request) { [weak self] response in
            switch response {
            case .success(let entities):
                let entity = entities
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
