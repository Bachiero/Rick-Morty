//
//  CharactersListGateway.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import Foundation

typealias CharactersListGatewayCompletion = (Result<CharactersListEntity, Error>) -> Void

protocol CharactersListGateway {
    func getCharactersList(with urlRequest: URLRequest, completion: @escaping CharactersListGatewayCompletion)
}

class CharactersListGatewayImpl: CharactersListGateway {
    
    private var task = URLSession.shared
    
    func getCharactersList(with urlRequest: URLRequest, completion: @escaping CharactersListGatewayCompletion) {
        
        let task = task.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(NetworkError.failedToGetData))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(CharactersListEntity.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
        self.task.invalidateAndCancel()
    }
}
