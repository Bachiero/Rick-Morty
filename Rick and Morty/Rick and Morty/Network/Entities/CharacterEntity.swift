//
//  CharacterEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

struct CharacterEntity: Codable {
    
    let info: Info
    let results: [CharacterInfo]

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    struct CharacterInfo: Codable {
        let id: Int
        let name: String
        let status: CharacterStatus
        let species: String
        let type: String
        let gender: CharacterGender
        let origin: Origin
        let location: Location
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }

    
    enum CharacterStatus: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
    
    enum CharacterGender: String, Codable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown = "unknown"
    }
    
    struct Origin: Codable {
        let name: String
        let url: String
    }
    
    struct Location: Codable {
        let name: String
        let url: String
    }
}
