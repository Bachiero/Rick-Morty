//
//  CharacterDetailsUseCaseTests.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

import XCTest
@testable import Rick_and_Morty

final class CharacterDetailsUseCaseTests: XCTestCase {
    
    var sut: CharacterDetailsUseCase!
    let gatewaySpy = CharacterInfoGatewaySpy()
    
    override func setUp() {
        super.setUp()
       
        sut = CharacterDetailsUseCaseImpl(gateway: gatewaySpy)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

//MARK: - Tests
extension CharacterDetailsUseCaseTests {
    func test_getCharacterDetails_withCorrectRequest_shouldReturnDetailsForCorrectCharacter() {
        let testEntity = CharacterInfoEntity.testBethEntity
        let characterId = testEntity.id
        let request = Request(endpoint: .character, pathComponents: [String(characterId)])
        
        gatewaySpy.characterInfoResult = .success(CharacterInfoEntity.testBethEntity)
        
        sut.getCharacterDetails(with: request) { response in
            if case .success(let entity) = response {
                XCTAssertEqual(entity.id, characterId)
            }
        }
    }
    
    func test_getCharacterDetailsWithUrl_shouldReturnDetails() {
        let characterUrl = "https://rickandmortyapi.com/api/character/1"
        
        gatewaySpy.characterInfoResult = .success(CharacterInfoEntity.testRickEntity)
        
        sut.getCharactersDetailsWithUrl(for: characterUrl) { response in
            if case .success(let entity) = response {
                XCTAssertEqual(entity.url, characterUrl)
            }
        }
    }
    
    func test_getCharacterDetailsWithIncorrectUrl_shouldReturnDetails() {
        let characterUrl = ""
        
        gatewaySpy.characterInfoResult = .success(CharacterInfoEntity.testRickEntity)
        
        sut.getCharactersDetailsWithUrl(for: characterUrl) { response in
            switch response {
            case .success:
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.failedToCreateRequest.localizedDescription)
            }
        }
    }
}
