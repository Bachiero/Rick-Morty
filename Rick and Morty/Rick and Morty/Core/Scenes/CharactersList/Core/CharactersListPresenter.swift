//
//  CharactersListPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation
import UIKit.UIImage

protocol CharactersListPresenter {
    func fetchCharacters(searchKeyword: String?)
    func getNumberOfRows() -> Int
    func getTableViewCellModel(for row: Int) -> CharactersListTableViewCellModel
}

final class CharactersListPresenterImpl: CharactersListPresenter {
   
    private unowned let view: CharactersListView
    private let router: CharactersListRouter
    
    private let charactersListUseCase: CharactersListUseCase
    private var dataSource: [CharactersListTableViewCellModel] = []
    
    init(
        view: CharactersListView,
        router: CharactersListRouter,
        charactersListUseCase: CharactersListUseCase
    ) {
        self.view = view
        self.router = router
        self.charactersListUseCase = charactersListUseCase
    }
    
    func getNumberOfRows() -> Int {
        return self.dataSource.count
    }
    
    func getTableViewCellModel(for row: Int) -> CharactersListTableViewCellModel {
        return dataSource[row]
    }
    
    func fetchCharacters(searchKeyword: String? = nil) {
        let request = Request(endpoint: .character)
        
        charactersListUseCase.getCharactersList(with: request) { [weak self] response in
            switch response {
            case .success(let entities):
                self?.createDataSource(from: entities)
                self?.view.reloadTableView()
            case .failure(let error):
                print(error.localizedDescription)
                //FIXME: show error. add some banner
            }
        }
    }
    
    private func convertEntitiesToModels(from entities: [CharacterDomainEntity]) -> [CharactersListTableViewCellModel] {
        entities.map { entity in
            CharactersListTableViewCellModel(
                image: entity.image,
                characterName: entity.name,
                status: entity.status.rawValue,
                type: entity.type
            )
        }
    }
    
    private func createDataSource(from entities: [CharacterDomainEntity]) {
        self.dataSource = self.convertEntitiesToModels(from: entities)
    }
}
