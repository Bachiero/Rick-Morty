//
//  CharacterDetailImageTableViewCellModel.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit.UIImage

struct CharacterDetailImageTableViewCellModel: TableViewRowViewModelable {
    let dequeueID: String = CharacterDetailImageTableViewCell.identifier
    let image: UIImage
}
