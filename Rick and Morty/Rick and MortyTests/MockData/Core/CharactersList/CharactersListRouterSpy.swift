//
//  CharactersListRouterSpy.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

import Foundation
@testable import Rick_and_Morty

class CharactersListRouterSpy: CharactersListRouter {
    var routeToDetailsCalled = false
    var routeToDetailsId: Int?
    func routeToDetails(characterId: Int) {
        routeToDetailsCalled = true
        routeToDetailsId = characterId
    }
}
