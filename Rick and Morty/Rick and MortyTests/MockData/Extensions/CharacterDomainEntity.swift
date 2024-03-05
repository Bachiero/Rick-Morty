//
//  CharacterDomainEntity.swift
//  Rick and MortyTests
//
//  Created by Bachuki Bitsadze on 05.03.24.
//

@testable import Rick_and_Morty
import UIKit.UIImage

extension CharacterDomainEntity {
    static var getTestEntity: CharacterDomainEntity {
        CharacterDomainEntity(
            id: 1,
            name: "Rick",
            status: .alive,
            species: "Human",
            type: "",
            gender: .male,
            origin: Origin(name: "Earth", url: ""),
            location: Location(name: "", url: ""),
            image: UIImage(),
            imageUrl: "",
            episode: [],
            url: "",
            created: ""
        )
    }
}


extension CharacterDomainEntity: Equatable {
    public static func == (lhs: CharacterDomainEntity, rhs: CharacterDomainEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.status == rhs.status &&
        lhs.species == rhs.species &&
        lhs.type == rhs.type &&
        lhs.gender == rhs.gender &&
        lhs.origin == rhs.origin &&
        lhs.location == rhs.location &&
        lhs.image == rhs.image &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.episode == rhs.episode &&
        lhs.url == rhs.url &&
        lhs.created == rhs.created
    }
}

extension CharacterDomainEntity.Origin: Equatable {
    public static func == (lhs: CharacterDomainEntity.Origin, rhs: CharacterDomainEntity.Origin) -> Bool {
        lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
}

extension CharacterDomainEntity.Location: Equatable {
    public static func == (lhs: CharacterDomainEntity.Location, rhs: CharacterDomainEntity.Location) -> Bool {
        lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
}
