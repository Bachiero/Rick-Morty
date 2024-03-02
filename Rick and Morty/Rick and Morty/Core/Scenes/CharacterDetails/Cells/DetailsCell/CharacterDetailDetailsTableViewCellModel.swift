//
//  CharacterDetailDetailsTableViewCellModel.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import Foundation

struct CharacterDetailDetailsTableViewCellModel: TableViewRowViewModelable {
    let dequeueID: String = CharacterDetailDetailsTableViewCell.identifier
    let details: [String]
}
