//
//  EpisodeDomainEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import UIKit.UIImage

class EpisodeDomainEntity {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    var characterImages: [UIImage]
    let url: String
    let created: String
    var characterEntities: [CharacterDomainEntity]
    
    init(
        id: Int,
        name: String,
        air_date: String,
        episode: String,
        characters: [String],
        characterImages: [UIImage],
        url: String,
        created: String,
        characterEntities:  [CharacterDomainEntity]
    ) {
        self.id = id
        self.name = name
        self.air_date = air_date
        self.episode = episode
        self.characters = characters
        self.characterImages = characterImages
        self.url = url
        self.created = created
        self.characterEntities = characterEntities
    }
}
