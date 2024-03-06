//
//  CharacterInfoGatewaySpy.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

@testable import Rick_and_Morty
import Foundation

class CharacterInfoGatewaySpy: CharacterInfoGateway {
    var characterInfoResult: Result<CharacterInfoEntity, Error>!
    func getCharacterInfo(with urlRequest: URLRequest, completion: @escaping CharacterInfoGatewayCompletion) {
        completion(characterInfoResult)
    }
}
