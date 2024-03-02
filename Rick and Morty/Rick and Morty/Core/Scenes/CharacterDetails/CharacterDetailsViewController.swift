//
//  CharacterDetailsViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharacterDetailsView: AnyObject {
    
}

///  Controller for details of selected character.
///  Here we show more iformation about the character, related episodes and other characters in those episodes.
final class CharacterDetailsViewController: UIViewController {
    
    //MARK: Properties
    var presenter: CharacterDetailsPresenter!
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Character Details"
        setupUI()
        
        presenter.viewDidLoad()

    }
    
    //MARK: - Setup UI
    private func setupUI() {
        setupHierarchy()
        setupLayout()
        setupAppearence()
       
    }
    
    private func setupHierarchy() {
       
    }
    
    private func setupLayout() {
     
        
    }
    
    private func setupAppearence() {
        view.backgroundColor = .systemGreen
    }
}

//MARK: - View interface conformance
extension CharacterDetailsViewController: CharacterDetailsView {
    
}
