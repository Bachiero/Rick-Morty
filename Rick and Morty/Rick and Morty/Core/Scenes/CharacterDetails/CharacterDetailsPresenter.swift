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
    func didSelectRow(at index: IndexPath)
    func dequeueID(row: Int) -> String
    func configure(cell: TableViewDequeueable, row: Int)
    func didScrollToBottom()
}

final class CharacterDetailsPresenterImpl: CharacterDetailsPresenter {
    private weak var view: CharacterDetailsView?
    private var characterId: Int
    private let characterDetailsUseCase: CharacterDetailsUseCase
    private let episodesUseCase: EpisodesUseCase
    private var dataSource: [TableViewRowViewModelable] = []
    private var characterEntity: CharacterDomainEntity?
    private var episodes: [EpisodeDomainEntity] = []
    
    private lazy var serviceQueue = ServiceQueue { [weak self] in
        self?.view?.stopLoader()
        self?.view?.reloadTableView()
    }
    
    init(view: CharacterDetailsView,
         characterDetailsUseCase: CharacterDetailsUseCase,
         episodesUseCase: EpisodesUseCase,
         characterId: Int
    ) {
        self.view = view
        self.characterId = characterId
        self.characterDetailsUseCase = characterDetailsUseCase
        self.episodesUseCase = episodesUseCase
    }
    
    deinit {
        serviceQueue.resetQueue()
    }
    
    func viewDidLoad() {
        view?.startLoader()
        fetchCharacterDetails(with: characterId)
    }
    
    func getNumberOfRows() -> Int {
        dataSource.count
    }
    
    func didSelectRow(at index: IndexPath) {
        switch dataSource[index.row] {
        case let viewModel as CharacterDetailsEpisodeTableViewCellModel:
            viewModel.isExpanded.toggle()
            view?.reloadTableView(indexPath: index)
        default: break
        }
    }
    
    func getDataSource() -> [TableViewRowViewModelable] {
        dataSource
    }
    
    func dequeueID(row: Int) -> String {
        guard row < dataSource.count else { return ""}
        return dataSource[row].dequeueID
    }
    
    func configure(cell: TableViewDequeueable, row: Int) {
        cell.configure(viewModel: dataSource[row])
    }
    
    func didScrollToBottom() {
        serviceQueue.enqueue()
        episodesUseCase.fetchNextPage { [weak self] response in
            switch response {
            case .success(let episodes):
                guard let entity = self?.characterEntity else { return }
                self?.episodes = episodes.filter { $0.characters.contains(entity.url) }
                self?.fetchCharacterEntitiesForEpisodes(episodes) {[weak self] episodes in
                    let models = self?.convertEntitiesToModels(from: episodes) ?? []
                    self?.createDataSource(with: entity, episodes: models)
                }
            case .failure(let error):
                self?.view?.showErrorMessage(error.localizedDescription)
               
            }
            self?.serviceQueue.dequeue()
        }
    }
}

//MARK: - Private methods
extension CharacterDetailsPresenterImpl {
    
    private func fetchCharacterDetails(with id: Int) {
        let request = Request(endpoint: .character, pathComponents: [String(id)])
        serviceQueue.enqueue()
        characterDetailsUseCase.getCharacterDetails(with: request) { [weak self] response in
            switch response {
            case .success(let entity):
                self?.characterEntity = entity
                self?.getEpisodes(with: entity) { [weak self] episodes in
                    let models = self?.convertEntitiesToModels(from: episodes) ?? []
                    self?.createDataSource(with: entity, episodes: models)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.serviceQueue.dequeue()
        }
    }
    
    private func getEpisodes(with entity: CharacterDomainEntity, completion: @escaping ([EpisodeDomainEntity]) -> Void) {
        let episodesRequest = Request(endpoint: .episode)
        serviceQueue.enqueue()
        episodesUseCase.getEpisodes(with: episodesRequest) { [weak self] response in
            switch response {
            case .success(let episodes):
                self?.episodes = episodes.filter { $0.characters.contains(entity.url)}
                self?.fetchCharacterEntitiesForEpisodes(episodes, completion: completion)
                
            case .failure(let error):
                self?.view?.showErrorMessage(error.localizedDescription)
            }
            self?.serviceQueue.dequeue()
        }
    }
    
    private func fetchCharacterEntitiesForEpisodes(_ episodes: [EpisodeDomainEntity], completion: @escaping ([EpisodeDomainEntity]) -> Void) {
        episodes.forEach { episode in
            episode.characters.forEach { character in
                getCharacter(for: character, completion: completion)
            }
        }
    }
        
    private func getCharacter(for characterUrl: String, completion: @escaping ([EpisodeDomainEntity]) -> Void) {
        self.view?.startLoader()
        serviceQueue.enqueue()
        characterDetailsUseCase.getCharactersDetailsWithUrl(for: characterUrl) { [weak self] response in
            switch response {
            case .success(let entity):
                self?.episodes.forEach { episode in
                    if episode.characters.contains(entity.url) {
                        episode.characterEntities.append(entity)
                    }
                }
                self?.episodes.forEach { episode in
                    episode.characterEntities = self?.removeDuplicateElements(entities: episode.characterEntities) ?? []
                    episode.characterEntities = episode.characterEntities.filter { $0.id != self?.characterId }
                }
                completion(self?.episodes ?? [])
            case .failure:
                break
            }
           
            self?.serviceQueue.dequeue()
        }
    }
    
    func removeDuplicateElements(entities: [CharacterDomainEntity]) -> [CharacterDomainEntity] {
        var uniqueEntities = [CharacterDomainEntity]()
        for entity in entities {
            if !uniqueEntities.contains(where: {$0.id == entity.id }) {
                uniqueEntities.append(entity)
            }
        }
        return uniqueEntities
    }
    
    private func createDataSource(with entity: CharacterDomainEntity, episodes: [CharacterDetailsEpisodeTableViewCellModel]) {
        self.dataSource = [
            CharacterDetailImageTableViewCellModel(image: entity.image),
            CharacterDetailDetailsTableViewCellModel(details: getDetailsTexts(from: entity)),
        ]
        dataSource.append(contentsOf: episodes)
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
    
    private func convertEntitiesToModels(from entities: [EpisodeDomainEntity]) -> [CharacterDetailsEpisodeTableViewCellModel] {
        entities.map {
            let images = $0.characterEntities
                .sorted { $0.id < $1.id }
                .map { $0.image }
            
            return CharacterDetailsEpisodeTableViewCellModel(
                id: $0.id,
                episodeName: $0.name,
                episodeAirDate: $0.air_date,
                characterImages: images,
                didSelectImageDelegate: self
            )
        }
    }
}

//MARK: CharactersCollectionViewDelegate
extension CharacterDetailsPresenterImpl: CharactersCollectionViewDelegate {
    func didSelect(collectionView: UICollectionView, cellAt cellIndex: Int) {
        guard let selectedEpisode = episodes.first(where: { String($0.id) == collectionView.accessibilityIdentifier } ) else { return }
        let characterUrl = selectedEpisode.characterEntities.sorted {$0.id < $1.id }[cellIndex].url
        let characterId = characterUrl.replacingOccurrences(of: "https://rickandmortyapi.com/api/character/", with: "")
        self.characterId = Int(characterId) ?? .zero
        fetchCharacterDetails(with: self.characterId)
    }
}
