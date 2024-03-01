//
//  CharactersListUseCase.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import Foundation

typealias CharactersListUseCaseCompletion = (Result<[CharacterDomainEntity],Error>) -> Void

protocol CharactersListUseCase {
    func getCharactersList(with request: Request, completion: @escaping CharactersListUseCaseCompletion)
}

struct CharactersListUseCaseImpl: CharactersListUseCase, UrlRequestFormattable {
    let gateway: CharactersListGateway
    
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
                completion(.success(entity.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
