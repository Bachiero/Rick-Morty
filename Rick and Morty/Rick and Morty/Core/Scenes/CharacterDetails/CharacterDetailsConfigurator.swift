//
//  CharacterDetailsConfigurator.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit.UIViewController

struct CharacterDetailsConfigurator {
    func configured(characterId: Int) -> UIViewController {
        let vc = CharacterDetailsViewController()
        let characterDetailsGateway = CharacterInfoGatewayImpl()
        let characterDetailsUseCase = CharacterDetailsUseCaseImpl(
            gateway: characterDetailsGateway
        )
        let episodesGateway = EpisodesGatewayImpl()
        let episodesUseCase = EpisodesUseCaseImpl(
            gateway: episodesGateway,
            characterId: characterId
        )
        
        vc.presenter = CharacterDetailsPresenterImpl(
            view: vc,
            characterDetailsUseCase: characterDetailsUseCase,
            episodesUseCase: episodesUseCase,
            characterId: characterId
        )
        
        return vc
    }
}
