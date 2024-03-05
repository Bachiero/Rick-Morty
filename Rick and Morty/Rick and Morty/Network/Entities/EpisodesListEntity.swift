//
//  EpisodesListEntity.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 04.03.24.
//

import Foundation

struct EpisodesListEntity: Codable {
    let info: Info
    let results: [EpisodeEntity]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
