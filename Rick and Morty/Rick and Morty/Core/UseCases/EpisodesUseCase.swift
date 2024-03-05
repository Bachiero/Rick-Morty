//
//  EpisodesUseCase.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 04.03.24.
//

import Foundation

typealias EpisodesUseCaseCompletion = (Result<[EpisodeDomainEntity], Error>) -> Void

protocol EpisodesUseCase {
    func getEpisodes(with request: Request, completion: @escaping EpisodesUseCaseCompletion)
    func fetchNextPage(completion: @escaping EpisodesUseCaseCompletion)
}

class EpisodesUseCaseImpl: EpisodesUseCase, UrlRequestFormattable {
    private let gateway: EpisodesGateway
    private var domainEntities: [EpisodeDomainEntity] = []
    private let characterId: Int
    private var nextPageUrl: String?
    
    init(gateway: EpisodesGateway,
         characterId: Int) {
        self.gateway = gateway
        self.characterId = characterId
    }
    
    func getEpisodes(with request: Request, completion: @escaping EpisodesUseCaseCompletion) {
        guard let urlRequest = getUrlRequest(from: request) else {
            completion(.failure(NetworkError.failedToCreateRequest))
            return
        }
        domainEntities = [] ///in case when navigated to new character, domainEntities should be emptied to correctly fetch new episodes
        getEpisodes(for: characterId, with: urlRequest, completion: completion)
    }
    
    func fetchNextPage(completion: @escaping EpisodesUseCaseCompletion) {
        guard let nextPageUrl,
              let url = URL(string: nextPageUrl) else {
            completion(.failure(NetworkError.noMoreData))
            return
        }
        let nextPageUrlRequest =  URLRequest(url: url)
        
        getEpisodes(for: characterId, with: nextPageUrlRequest, completion: completion)
    }
}

//MARK: - Private methods
extension EpisodesUseCaseImpl: FetchImageAccessible {
    
    private func getEpisodes(for characterId: Int, with urlRequest: URLRequest, completion: @escaping EpisodesUseCaseCompletion) {
        gateway.getEpisodes(with: urlRequest) {[weak self] response in
            guard let self else { return }
            switch response {
            case .success(let entity):
                nextPageUrl = entity.info.next
                let episodes = convertApiEntityToDomainEntity(from: entity.results)
                let filtered = filtered(episodes: episodes, by: characterId)
                
                ///while api returns only 20 episodes. if character isn't in those first 20, there is empty list of episodes, which is a bug.
                if filtered.count == .zero {
                    fetchNextPage(completion: completion)
                    return /// we don't need completion with empty data so we return from here
                }
               
                domainEntities = getUpdatedEntities(with: filtered, update: nextPageUrl != nil)
                completion(.success(domainEntities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func filtered(episodes: [EpisodeDomainEntity], by characterId: Int) -> [EpisodeDomainEntity] {
        let characterUrl = Request(endpoint: .character, pathComponents: [String(characterId)]).getUrlString()
        return episodes.filter { $0.characters.contains(characterUrl)}
    }
    
    private func convertApiEntityToDomainEntity(from entities: [EpisodeEntity]) -> [EpisodeDomainEntity] {
        entities.compactMap { entity in
            EpisodeDomainEntity(
                id: entity.id,
                name: entity.name,
                air_date: entity.air_date,
                episode: entity.episode,
                characters: entity.characters,
                characterImages: [],
                url: entity.url,
                created: entity.created,
                characterEntities: []
            )
        }
    }
    
    
    
    private func getUpdatedEntities(with data: [EpisodeDomainEntity], update: Bool) -> [EpisodeDomainEntity] {
        return update ? domainEntities + data : data
    }
}
