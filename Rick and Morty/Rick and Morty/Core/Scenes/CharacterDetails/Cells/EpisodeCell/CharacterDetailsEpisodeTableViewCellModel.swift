//
//  CharacterDetailsEpisodeTableViewCellModel.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 03.03.24.
//

import UIKit

class CharacterDetailsEpisodeTableViewCellModel: TableViewRowViewModelable {
    let dequeueID: String = CharacterDetailsEpisodeTableViewCell.identifier
    let episodeName: String
    let episodeAirDate: String
    let characterImages: [UIImage]
    var isExpanded: Bool
    let didSelectImageDelegate: CharactersCollectionViewDelegate?
    
    init(
        episodeName: String,
        episodeAirDate: String,
        characterImages: [UIImage],
        isExpanded: Bool = false,
        didSelectImageDelegate: CharactersCollectionViewDelegate?
    ) {
        self.episodeName = episodeName
        self.episodeAirDate = episodeAirDate
        self.characterImages = characterImages
        self.isExpanded = isExpanded
        self.didSelectImageDelegate = didSelectImageDelegate
    }
}
