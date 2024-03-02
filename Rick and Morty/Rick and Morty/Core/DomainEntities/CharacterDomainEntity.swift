//
//  CharacterDomainEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import UIKit.UIImage

class CharacterDomainEntity {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: Origin
    let location: Location
    var image: UIImage
    let imageUrl: String
    let episode: [String]
    let url: String
    let created: String
    
    init(
        id: Int,
        name: String,
        status: CharacterStatus,
        species: String,
        type: String,
        gender: CharacterGender,
        origin: Origin,
        location: Location,
        image: UIImage,
        imageUrl: String,
        episode: [String],
        url: String,
        created: String
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.imageUrl = imageUrl
        self.episode = episode
        self.url = url
        self.created = created
    }
    
    enum CharacterStatus: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
    
    enum CharacterGender: String{
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }
    
    struct Origin {
        let name: String
        let url: String
    }
    
    struct Location {
        let name: String
        let url: String
    }
}
