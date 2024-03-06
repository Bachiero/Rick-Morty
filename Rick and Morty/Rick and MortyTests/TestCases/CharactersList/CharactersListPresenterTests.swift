//
//  CharactersListPresenterTests.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

import Foundation
import XCTest
@testable import Rick_and_Morty

final class CharactersListPresenterTests: XCTestCase {
    
    var sut: CharactersListPresenter!
    var view: CharactersListViewSpy!
    var router: CharactersListRouterSpy!
    var useCase: CharactersListUseCaseSpy!
   
    override func setUp() {
        super.setUp()
       
        view = CharactersListViewSpy()
        router = CharactersListRouterSpy()
        useCase = CharactersListUseCaseSpy()
        
        sut = CharactersListPresenterImpl(
            view: view,
            router: router,
            charactersListUseCase: useCase
        )
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
}

//MARK: - Tests
extension CharactersListPresenterTests {
    func test_initialFetchCharacters() {
        let response: [CharacterDomainEntity] = [CharacterDomainEntity.getRickEntity, CharacterDomainEntity.getMortyEntity]
        useCase.getCharactersListResult = .success(response)
        
        sut.fetchCharacters(searchKeyword: nil)
        
        XCTAssertTrue(view.startLoaderCalled)
        XCTAssertTrue(view.reloadTableViewCalled)
        XCTAssertFalse(view.showErrorMessageCalled)
        XCTAssertEqual(response.count, sut.getNumberOfRows())
    }
    
    func test_getNumberOfRows_shouldReturnCorrectNumber() {
        let response: [CharacterDomainEntity] = [
            CharacterDomainEntity.getRickEntity,
            CharacterDomainEntity.getMortyEntity,
            CharacterDomainEntity.getRickEntity,
            CharacterDomainEntity.getMortyEntity]
        useCase.getCharactersListResult = .success(response)
        sut.fetchCharacters(searchKeyword: nil)
        XCTAssertEqual(sut.getNumberOfRows(), response.count)
    }
    
    func test_didScrollToBottom_shouldFetchMoreChracters() {
        let response: [CharacterDomainEntity] = [CharacterDomainEntity.getRickEntity, CharacterDomainEntity.getMortyEntity]
        useCase.getCharactersListResult = .success(response)
        
     
        let nextPageResponse: [CharacterDomainEntity] = [CharacterDomainEntity.getMortyEntity]
        useCase.fetchNextPageResult = .success(nextPageResponse)
        
        sut.didScrollToBottom()
        
        XCTAssertTrue(view.startLoaderCalled)
        XCTAssertTrue(view.reloadTableViewCalled)
        XCTAssertEqual(sut.getNumberOfRows(), 1)
        
    }
    
    func test_didSelectCharacter_shouldNavigateToDetailsPage() {
        let response: [CharacterDomainEntity] = [CharacterDomainEntity.getRickEntity, CharacterDomainEntity.getMortyEntity]
        useCase.getCharactersListResult = .success(response)
        sut.fetchCharacters(searchKeyword: nil)
        let index = 0
        sut.didSelectCharacter(at: index)
        
        XCTAssertTrue(router.routeToDetailsCalled)
        XCTAssertEqual(router.routeToDetailsId, response[index].id)
        
    }
}
