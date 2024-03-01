//
//  EpisodeDomainEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 01.03.24.
//

import Foundation

struct EpisodeDomainEntity: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
