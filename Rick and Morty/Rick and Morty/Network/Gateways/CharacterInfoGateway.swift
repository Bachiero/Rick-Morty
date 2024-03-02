//
//  CharacterInfoGateway.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 02.03.24.
//

import Foundation

typealias CharacterInfoGatewayCompletion = (Result<CharacterInfoEntity, Error>) -> Void

protocol CharacterInfoGateway {
    func getCharacterInfo(with urlRequest: URLRequest, completion: @escaping CharacterInfoGatewayCompletion)
}

struct CharacterInfoGatewayImpl: CharacterInfoGateway {
    
    func getCharacterInfo(with urlRequest: URLRequest, completion: @escaping CharacterInfoGatewayCompletion) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(NetworkError.failedToGetData))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(CharacterInfoEntity.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
