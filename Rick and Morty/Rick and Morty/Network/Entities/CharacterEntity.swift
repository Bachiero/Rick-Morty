//
//  CharacterEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

struct CharacterEntity: Codable {
    
    let info: Info
    let results: [CharacterDomainEntity]

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
