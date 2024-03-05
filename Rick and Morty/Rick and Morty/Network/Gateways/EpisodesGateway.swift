//
//  EpisodesGateway.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 04.03.24.
//

import Foundation

typealias EpisodesGatewayCompletion = (Result<EpisodesListEntity, Error>) -> Void

protocol EpisodesGateway {
    func getEpisodes(with urlRequest: URLRequest, completion: @escaping EpisodesGatewayCompletion)
}

struct EpisodesGatewayImpl: EpisodesGateway {
    
    func getEpisodes(with urlRequest: URLRequest, completion: @escaping EpisodesGatewayCompletion) {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(NetworkError.failedToGetData))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(EpisodesListEntity.self, from: data)
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

