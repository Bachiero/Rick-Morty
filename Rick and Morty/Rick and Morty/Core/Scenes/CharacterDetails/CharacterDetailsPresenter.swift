//
//  CharacterDetailsPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIImage

protocol CharacterDetailsPresenter {
    func viewDidLoad()
    func getNumberOfRows() -> Int
    func didSelectEpisode(at index: Int)
    func getTableViewCellModel(for row: Int) -> CharactersListTableViewCellModel
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
    
    func getNumberOfRows() -> Int {
        1
    }
    
    func didSelectEpisode(at index: Int) {
        
    }
    
    func getTableViewCellModel(for row: Int) -> CharactersListTableViewCellModel {
        CharactersListTableViewCellModel(id: 1, image: UIImage(), characterName: "ads", status: "asd", type: "asd")
    }
    
    private func fetchCharacterDetails(with id: Int) {
        let request = Request(endpoint: .character, pathComponents: [String(id)])
        
        view.startLoader()
        characterDetailsUseCase.getCharacterDetails(with: request) { [weak self] response in
            switch response {
            case .success(let entity):
                self?.view.setupImage(entity.image)
                if let details = self?.getDetailsTexts(from: entity) {
                    self?.view.setupDetailsStack(with: details)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.view.stopLoader()
        }
    }
    
    private func getDetailsTexts(from entity: CharacterDomainEntity) -> [String] {
        var details: [String] = []
        details.append("Status: \(entity.status)")
        details.append("Species: \(entity.species)")
        details.append("Type: \(entity.type)")
        details.append("Gender: \(entity.gender)")
        details.append("Origin: \(entity.origin.name)")
        details.append("Location: \(entity.location.name)")
        return details
    }
}
