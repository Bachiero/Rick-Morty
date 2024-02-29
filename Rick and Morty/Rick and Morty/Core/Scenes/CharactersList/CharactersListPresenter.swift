//
//  CharactersListPresenter.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import Foundation

protocol CharactersListPresenter {
    func initialSetup()
}

final class CharactersListPresenterImpl: CharactersListPresenter {
   
    
    private unowned let view: CharactersListView
    private let router: CharactersListRouter
    
    init(view: CharactersListView, router: CharactersListRouter) {
        self.view = view
        self.router = router
    }
    
    func initialSetup() {
        
    }
    
}
