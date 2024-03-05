//
//  CharactersListGatewaySpy.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 05.03.24.
//
import Foundation
@testable import Rick_and_Morty

class CharactersListGatewaySpy: CharactersListGateway {
    var charactersListResult: Result<CharactersListEntity, Error>!
    
    func getCharactersList(with urlRequest: URLRequest, completion: @escaping CharactersListGatewayCompletion) {
        completion(charactersListResult)
    }
}
