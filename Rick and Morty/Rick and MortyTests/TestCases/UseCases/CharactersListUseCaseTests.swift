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

extension CharactersListUseCaseTests {
    func test_f() {
//        let expectedResult: [CharacterDomainEntity] = [
//            CharacterDomainEntity.getTestEntity,
//            CharacterDomainEntity.getTestEntity
//        ]
//        
//        gatewaySpy.charactersListResult = .success(
//            CharactersListEntity(info: CharactersListEntity.Info(count: 1, pages: 1, next: "", prev: ""),
//                                 results: expectedResult))
//        let Request = Request(endpoint: .character)
//        sut.getCharactersList(with: Request) { response in
//            if case .success(let entities) = response {
//                XCTAssertEqual(entities, expectedResult)
//            }
//        }
    }
}
