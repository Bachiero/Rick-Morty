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
    private unowned let view: CharacterDetailsView
    private let router: CharacterDetailsRouter
    private let characterId: Int
    private let characterDetailsUseCase: CharacterDetailsUseCase
    private let episodesUseCase: EpisodesUseCase
    private var dataSource: [TableViewRowViewModelable] = []
    private var characterEntity: CharacterDomainEntity?
    private var episodes: [EpisodeDomainEntity] = []
    
    private lazy var serviceQueue = ServiceQueue { [weak self] in
        guard let self = self else { return }
        self.view.stopLoader()
        self.view.reloadTableView()
    }
    
    init(view: CharacterDetailsView,
         router: CharacterDetailsRouter,
         characterDetailsUseCase: CharacterDetailsUseCase,
         episodesUseCase: EpisodesUseCase,
         characterId: Int
    ) {
        self.view = view
        self.router = router
        self.characterId = characterId
        self.characterDetailsUseCase = characterDetailsUseCase
        self.episodesUseCase = episodesUseCase
    }
    
    deinit {
        serviceQueue.resetQueue()
    }
    
    func viewDidLoad() {
        view.startLoader()
        fetchCharacterDetails(with: characterId)
    }
    
    func getNumberOfRows() -> Int {
        dataSource.count
    }
    
    func didSelectRow(at index: IndexPath) {
        switch dataSource[index.row] {
        case let viewModel as CharacterDetailsEpisodeTableViewCellModel:
            viewModel.isExpanded.toggle()
            view.reloadTableView(indexPath: index)
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
                self?.addImagesToEpisodes(episodes: episodes) { [weak self] episodes in
                    guard let self,
                          let characterEntity = characterEntity else { return }
                    let episodesModels = convertEntitiesToModels(from: episodes)
                    createDataSource(with: characterEntity, episodes: episodesModels)
                    serviceQueue.dequeue()
                }
            case .failure(let error):
                self?.view.showErrorMessage(error.localizedDescription)
                self?.serviceQueue.dequeue()
            }
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
                self?.getEpisodes(with: entity)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.serviceQueue.dequeue()
        }
    }
    
    
    private func getEpisodes(with entity: CharacterDomainEntity) {
        let episodesRequest = Request(endpoint: .episode)
        serviceQueue.enqueue()
        episodesUseCase.getEpisodes(with: episodesRequest) { [weak self] response in
            switch response {
            case .success(let episodes):
                self?.episodes = episodes
                self?.addImagesToEpisodes(episodes: episodes) { episodes in
                    let episodesModels = self?.convertEntitiesToModels(from: episodes) ?? []
                    self?.createDataSource(with: entity, episodes: episodesModels)
                    self?.serviceQueue.dequeue()
                }
            case .failure(let error):
                self?.view.showErrorMessage(error.localizedDescription)
                self?.serviceQueue.dequeue()
            }
        }
    }
    
    private func addImagesToEpisodes(episodes: [EpisodeDomainEntity], completion: @escaping ([EpisodeDomainEntity]) -> Void) {
        episodes.forEach { episode in
            episode.characters.forEach { character in
                getCharacterEntity(for: character) { characterEntity in
                    episode.characterImages.append(characterEntity.image)
                    completion(episodes)
                }
            }
        }
    }
    
    private func getCharacterEntity(for characterUrl: String, completion: @escaping (CharacterDomainEntity) -> Void) {
        view.startLoader()
        serviceQueue.enqueue()
        characterDetailsUseCase.getCharactersDetailsWithUrl(for: characterUrl) { [weak self] response in
            switch response {
            case .success(let characterEntity):
                if characterEntity.id != self?.characterId {
                    completion(characterEntity)
                }
            case .failure(let error):
                self?.view.showErrorMessage(error.localizedDescription)
            }
            self?.serviceQueue.dequeue()
        }
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
            CharacterDetailsEpisodeTableViewCellModel(
                episodeName: $0.name,
                episodeAirDate: $0.air_date,
                characterImages: $0.characterImages,
                didSelectImageDelegate: self
            )}
    }
    
    private func appendEpisodesToDataSource(from entities: [EpisodeDomainEntity]) {
        entities.forEach {
            dataSource.append(
                CharacterDetailsEpisodeTableViewCellModel(
                    episodeName: $0.name,
                    episodeAirDate: $0.air_date,
                    characterImages: $0.characterImages,
                    didSelectImageDelegate: self
                )
            )
        }
    }
}

//MARK: CharactersCollectionViewDelegate
extension CharacterDetailsPresenterImpl: CharactersCollectionViewDelegate {
    func didSelect(collectionView: UICollectionView, cellAt cellIndex: Int) {
        guard let selectedEpisode = episodes.first(where: { $0.name == collectionView.accessibilityIdentifier } ) else { return }
        let characterUrl = selectedEpisode.characters[cellIndex]
        serviceQueue.enqueue()
        characterDetailsUseCase.getCharactersDetailsWithUrl(for: characterUrl) { [weak self] response in
            switch response {
            case .success(let entity):
                self?.characterEntity = entity
                self?.getEpisodes(with: entity)
            case .failure(let error):
                print(error.localizedDescription)
            }
            self?.serviceQueue.dequeue()
        }
    }
}
