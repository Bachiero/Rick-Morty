//
//  CharacterInfoEntity.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 06.03.24.
//

@testable import Rick_and_Morty

extension CharacterInfoEntity {
    static var testRickEntity: CharacterInfoEntity {
        CharacterInfoEntity(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: Origin(name: "Earth C-137", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "https://rickandmortyapi.com/api/character/1",
            created: ""
        )
    }
    
    static var testMortyEntity: CharacterInfoEntity {
        CharacterInfoEntity(
            id: 2,
            name: "Morty",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: Origin(name: "Earth C-137", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )
    }
    
    static var testBethEntity: CharacterInfoEntity {
        CharacterInfoEntity(
            id: 3,
            name: "Beth",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: Origin(name: "Earth C-137", url: ""),
            location: Location(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )
    }
}
