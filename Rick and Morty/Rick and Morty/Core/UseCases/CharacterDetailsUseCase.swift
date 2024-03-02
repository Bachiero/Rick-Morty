//
//  CharacterDetailsUseCase.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 02.03.24.
//


import UIKit

typealias CharacterDetailsUseCaseCompletion = (Result<CharacterDomainEntity,Error>) -> Void

protocol CharacterDetailsUseCase {
    func getCharacterDetails(with request: Request, completion: @escaping CharacterDetailsUseCaseCompletion)
}

class CharacterDetailsUseCaseImpl: CharacterDetailsUseCase, UrlRequestFormattable {
    private let gateway: CharacterInfoGateway
    
    init(gateway: CharacterInfoGateway) {
        self.gateway = gateway
    }
    
    func getCharacterDetails(with request: Request, completion: @escaping CharacterDetailsUseCaseCompletion) {
        guard let urlRequest = getUrlRequest(from: request) else {
            completion(.failure(NetworkError.failedToCreateRequest))
            return
        }
        getCharacterInfo(with: urlRequest, completion: completion)
    }
}

//MARK: - Private methods
extension CharacterDetailsUseCaseImpl: FetchImageAccessible {
    
    private func getCharacterInfo(with urlRequest: URLRequest, completion: @escaping CharacterDetailsUseCaseCompletion) {
        gateway.getCharacterInfo(with: urlRequest) {[weak self] response in
            
            switch response {
            case .success(let entity):
                let domainEntity = self?.convertApiEntityToDomainEntity(from: entity)
                self?.fetchCharacterImage(from: domainEntity, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func convertApiEntityToDomainEntity(from entity: CharacterInfoEntity) -> CharacterDomainEntity {
        return CharacterDomainEntity(
            id: entity.id,
            name: entity.name,
            status: CharacterDomainEntity.CharacterStatus(rawValue: entity.status.rawValue) ?? .unknown,
            species: entity.species,
            type: entity.type,
            gender: CharacterDomainEntity.CharacterGender(rawValue: entity.gender.rawValue) ?? .unknown,
            origin: CharacterDomainEntity.Origin(name: entity.origin.name, url: entity.origin.url),
            location: CharacterDomainEntity.Location(name: entity.location.name, url: entity.location.url),
            image: UIImage(named: "image_placeholder") ?? UIImage(),
            imageUrl: entity.image,
            episode: entity.episode,
            url: entity.url,
            created: entity.created
        )
    }
    
    private func fetchCharacterImage(from entity: CharacterDomainEntity?,
                                     completion: @escaping CharacterDetailsUseCaseCompletion) {
        guard let entity else {
            completion(.failure(NetworkError.failedToGetData))
            return
        }
        if let url = URL(string: entity.imageUrl) {
            fetchImage(from: url) { result in
                if case .success(let image) = result {
                    entity.image = image
                }
                completion(.success(entity))
            }
        }
    }
}
