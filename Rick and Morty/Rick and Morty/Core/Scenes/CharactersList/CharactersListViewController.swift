//
//  CharactersListViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharactersListView: AnyObject {
    
}

final class CharactersListViewController: UIViewController {
    //MARK: Properties
    var presenter: CharactersListPresenter!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.initialSetup()
        
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
        view.backgroundColor = .systemMint
    }
    
}

//MARK: - View interface conformance
extension CharactersListViewController: CharactersListView {
    
    
}
