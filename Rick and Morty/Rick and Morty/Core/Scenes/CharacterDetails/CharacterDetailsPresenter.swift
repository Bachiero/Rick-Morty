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
    func didSelectRow(at index: Int)
    func dequeueID(row: Int) -> String
    func configure(cell: TableViewDequeueable, row: Int)
}

final class CharacterDetailsPresenterImpl: CharacterDetailsPresenter {
    private unowned let view: CharacterDetailsView
    private let router: CharacterDetailsRouter
    private let characterId: Int
    private let characterDetailsUseCase: CharacterDetailsUseCase
    private var dataSource: [TableViewRowViewModelable] = []
    
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
        dataSource.count
    }
    
    func didSelectRow(at index: Int) {
        
    }
    
    func getDataSource() -> [TableViewRowViewModelable] {
        dataSource
    }
    
    func dequeueID(row: Int) -> String {
        dataSource[row].dequeueID
    }
    
    func configure(cell: TableViewDequeueable, row: Int) {
        cell.configure(viewModel: dataSource[row])
    }
    
    private func fetchCharacterDetails(with id: Int) {
        let request = Request(endpoint: .character, pathComponents: [String(id)])
        
        view.startLoader()
        characterDetailsUseCase.getCharacterDetails(with: request) { [weak self] response in
            switch response {
            case .success(let entity):
                self?.createDataSource(with: entity)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.view.reloadTableView()
            self?.view.stopLoader()
        }
    }
    
    private func createDataSource(with entity: CharacterDomainEntity) {
        self.dataSource = [
            CharacterDetailImageTableViewCellModel(image: entity.image),
            CharacterDetailDetailsTableViewCellModel(details: getDetailsTexts(from: entity))
        ]
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
