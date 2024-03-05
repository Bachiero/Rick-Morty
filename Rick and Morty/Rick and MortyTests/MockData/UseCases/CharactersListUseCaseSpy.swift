//
//  CharactersListUseCaseSpy.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 05.03.24.
//

@testable import Rick_and_Morty

class CharactersListUseCaseSpy: CharactersListUseCase {
    var getCharactersListResult: Result<[CharacterDomainEntity],Error>!
    var fetchNextPageResult: Result<[CharacterDomainEntity],Error>!
    
    func getCharactersList(with request: Request, completion: @escaping CharactersListUseCaseCompletion) {
        completion(getCharactersListResult)
    }
    
    func fetchNextPage(completion: @escaping CharactersListUseCaseCompletion) {
        completion(fetchNextPageResult)
    }
}

