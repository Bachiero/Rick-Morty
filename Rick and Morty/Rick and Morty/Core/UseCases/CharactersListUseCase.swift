//
//  CharactersListUseCase.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import UIKit

typealias CharactersListUseCaseCompletion = (Result<[CharacterDomainEntity],Error>) -> Void

protocol CharactersListUseCase {
    func getCharactersList(with request: Request, completion: @escaping CharactersListUseCaseCompletion)
    func fetchNextPage(completion: @escaping CharactersListUseCaseCompletion)
}

class CharactersListUseCaseImpl: CharactersListUseCase, UrlRequestFormattable {
    private let gateway: CharactersListGateway
    private let dispatchGroup = DispatchGroup()
    private var domainEntities: [CharacterDomainEntity] = []
    private var nextPageUrl: String?

    init(gateway: CharactersListGateway) {
        self.gateway = gateway
    }
    
    func getCharactersList(with request: Request, completion: @escaping CharactersListUseCaseCompletion) {
        
        guard let urlRequest = getUrlRequest(from: request) else {
            completion(.failure(NetworkError.failedToCreateRequest))
            return
        }
        domainEntities = [] ///in case when tableView is reloaded, domainEntities should be emptied to correctly refresh the tabel with initial setup
        getCharacters(with: urlRequest, completion: completion)
    }
    
    func fetchNextPage(completion: @escaping CharactersListUseCaseCompletion) {
        guard let nextPageUrl,
              let url = URL(string: nextPageUrl) else {
            completion(.failure(NetworkError.noMoreData))
            return
        }
        let nextPageUrlRequest =  URLRequest(url: url)
        
        getCharacters(with: nextPageUrlRequest, completion: completion)
    }
}

//MARK: - Private methods
extension CharactersListUseCaseImpl {
    
    private func getCharacters(with urlRequest: URLRequest, completion: @escaping CharactersListUseCaseCompletion) {
        gateway.getCharactersList(with: urlRequest) {[weak self] response in
            switch response {
            case .success(let entity):
                let domainEntity = self?.convertApiEntityToDomainEntity(from: entity) ?? []
                self?.nextPageUrl = entity.info.next
                self?.fetchChatracterImages(from: domainEntity, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchChatracterImages(from entities: [CharacterDomainEntity],
                         completion: @escaping CharactersListUseCaseCompletion) {
        
        entities.forEach { item in
            if let url = URL(string: item.imageUrl) {
                dispatchGroup.enter()
                fetchImage(from: url) {[weak self] result in
                    if case .success(let image) = result {
                        item.image = image
                        self?.dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(qos: .default, queue: .main) { [weak self] in
            guard let self else {
                completion(.failure(NetworkError.failedToGetData))
                return
            }
            domainEntities = getUpdatedEntities(with: entities, update: nextPageUrl != nil)
            completion(.success(domainEntities))
        }
    }
    
    private func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) ->Void ) {
        let task = URLSession.shared.dataTask(with: url) { data,_,_ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal) ?? UIImage()
                completion(.success(image))
            }
        }
        task.resume()
    }
    
    private func convertApiEntityToDomainEntity(from entity: CharacterEntity) -> [CharacterDomainEntity] {
        entity.results.compactMap { character in
            return CharacterDomainEntity(
                id: character.id,
                name: character.name,
                status: CharacterDomainEntity.CharacterStatus(rawValue: character.status.rawValue) ?? .unknown,
                species: character.species,
                type: character.type,
                gender: CharacterDomainEntity.CharacterGender(rawValue: character.gender.rawValue) ?? .unknown,
                origin: CharacterDomainEntity.Origin(name: character.origin.name, url: character.origin.url),
                location: CharacterDomainEntity.Location(name: character.location.name, url: character.location.url),
                image: UIImage(named: "evil_morty") ?? UIImage(),
                imageUrl: character.image,
                episode: character.episode,
                url: character.url,
                created: character.created
            )
        }
    }
    
    private func getUpdatedEntities(with data: [CharacterDomainEntity], update: Bool) -> [CharacterDomainEntity] {
        return update ? domainEntities + data : data
    }
}
