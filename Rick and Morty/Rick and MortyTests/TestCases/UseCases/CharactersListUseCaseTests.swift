//
//  CharactersListUseCaseTests.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 05.03.24.
//

import XCTest
@testable import Rick_and_Morty

final class CharactersListUseCaseTests: XCTestCase {
    
    var sut: CharactersListUseCase!
    let gatewaySpy = CharactersListGatewaySpy()
    
    override func setUp() {
        super.setUp()
       
        sut = CharactersListUseCaseImpl(gateway: gatewaySpy)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

//MARK: - Tests
extension CharactersListUseCaseTests {
    func test_getCharactersList_shouldReturnCorrectDomainEntities() {
        let testEntities: [CharacterInfoEntity] = [
            CharacterInfoEntity.testRickEntity,
            CharacterInfoEntity.testMortyEntity
        ]
        
        let expectedResult = convertApiEntityToDomainEntity(from: testEntities)
        
        gatewaySpy.charactersListResult = .success(
            CharactersListEntity(info: CharactersListEntity.Info(count: 1, pages: 1, next: "", prev: ""),
                                 results: testEntities))
        let request = Request(endpoint: .character)
        sut.getCharactersList(with: request) { response in
            if case .success(let entities) = response {
                XCTAssertEqual(entities, expectedResult)
            }
        }
    }
    
    func test_getNextPage_withUrl_shouldReturnEntities() {
        let testEntities: [CharacterInfoEntity] = [
            CharacterInfoEntity.testRickEntity,
            CharacterInfoEntity.testMortyEntity
        ]
        
        let expectedResult = convertApiEntityToDomainEntity(from: testEntities)
        
        gatewaySpy.charactersListResult = .success(
            CharactersListEntity(info: CharactersListEntity.Info(count: 1, pages: 1, next: "next_page_url", prev: ""),
                                 results: testEntities))
        let request = Request(endpoint: .character)
        sut.getCharactersList(with: request) {_ in }
        
        sut.fetchNextPage() { response in
            switch response {
            case .success(let entities):
                XCTAssertEqual(entities, expectedResult)
            case .failure:
                XCTAssertTrue(false)
            }
        }
    }
    
    func test_getNextPage_withoutNextPageUrl_shouldNotReturnNewData() {
        let testEntities: [CharacterInfoEntity] = [
            CharacterInfoEntity.testRickEntity,
            CharacterInfoEntity.testMortyEntity
        ]
        
        gatewaySpy.charactersListResult = .success(CharactersListEntity(
            info: CharactersListEntity.Info(count: 1, pages: 1, next: nil, prev: ""),
            results: testEntities))
        let request = Request(endpoint: .character)
        sut.getCharactersList(with: request) {_ in }
        
        sut.fetchNextPage() { response in
            switch response {
            case .success:
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.noMoreData.localizedDescription)
            }
        }
    }
    
    func test_getNextPage_withEmptyUrl_shouldNotReturnNewData() {
        let testEntities: [CharacterInfoEntity] = [
            CharacterInfoEntity.testRickEntity,
            CharacterInfoEntity.testMortyEntity
        ]
        
        gatewaySpy.charactersListResult = .success(CharactersListEntity(
            info: CharactersListEntity.Info(count: 1, pages: 1, next: "", prev: ""),
            results: testEntities))
        let request = Request(endpoint: .character)
        sut.getCharactersList(with: request) {_ in }
        
        sut.fetchNextPage() { response in
            switch response {
            case .success:
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.noMoreData.localizedDescription)
            }
        }
    }
}

//MARK: - Helpers
extension CharactersListUseCaseTests {
    
    private func convertApiEntityToDomainEntity(from entities: [CharacterInfoEntity]) -> [CharacterDomainEntity] {
        entities.compactMap { entity in
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
    }
}
