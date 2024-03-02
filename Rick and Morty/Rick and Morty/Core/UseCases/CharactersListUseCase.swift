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
}

struct CharactersListUseCaseImpl: CharactersListUseCase, UrlRequestFormattable {
    private let gateway: CharactersListGateway
    private let dispatchGroup = DispatchGroup()
    
    init(gateway: CharactersListGateway) {
        self.gateway = gateway
    }
    
    func getCharactersList(with request: Request, completion: @escaping CharactersListUseCaseCompletion) {
        
        guard let urlRequest = getUrlRequest(from: request) else {
            completion(.failure(NetworkError.failedToCreateRequest))
            return
        }
        gateway.getCharactersList(with: urlRequest) { response in
            switch response {
            case .success(let entity):
                let domainEntity = convertApiEntityToDomainEntity(from: entity)
                fetchChatracterImages(from: domainEntity, completion: completion)
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
                fetchImage(from: url) { result in
                    if case .success(let image) = result {
                        item.image = image
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(qos: .default, queue: .main) {
            completion(.success(entities))
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
}
