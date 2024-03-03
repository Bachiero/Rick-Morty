//
//  CharacterDetailsViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharacterDetailsView: AnyObject {
    func reloadTableView()
    func startLoader()
    func stopLoader()
}

///  Controller for details of selected character.
///  Here we show more iformation about the character, related episodes and other characters in those episodes.
final class CharacterDetailsViewController: UIViewController {
    
    //MARK: Properties
    var presenter: CharacterDetailsPresenter!
    
    //FIXME: Move character image and detailsStack to tableView cells and configure the page with tv only.
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CharacterDetailImageTableViewCell.self, forCellReuseIdentifier: CharacterDetailImageTableViewCell.identifier)
        table.register(CharacterDetailDetailsTableViewCell.self, forCellReuseIdentifier: CharacterDetailDetailsTableViewCell.identifier)
        table.register(CharacterDetailsEpisodeTableViewCell.self, forCellReuseIdentifier: CharacterDetailsEpisodeTableViewCell.identifier)
        table.layer.cornerRadius = 16
        return table
    }()
    
    private let loaderIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.color = .systemOrange
        return loader
    }()
    
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
        view.addSubview(tableView)
        view.addSubview(loaderIndicator)
    }
    
    private func setupLayout() {
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
     
        let loaderConstraints: [NSLayoutConstraint] = [
            loaderIndicator.heightAnchor.constraint(equalToConstant: 60),
            loaderIndicator.widthAnchor.constraint(equalToConstant: 60),
            loaderIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        [tableViewConstraints, loaderConstraints].forEach { NSLayoutConstraint.activate($0)}
    }
    
    private func setupAppearence() {
        view.backgroundColor = Colors.RickDomColorPalette.purpleGrey
        tableView.backgroundColor = Colors.RickDomColorPalette.lightGrey
    }
    
    
    
}

//MARK: - View interface conformance
extension CharacterDetailsViewController: CharacterDetailsView {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func startLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loaderIndicator.startAnimating()
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loaderIndicator.stopAnimating()
        }
    }
}

//MARK: - Private methods
extension CharacterDetailsViewController {
    
}

//MARK: - TableView's delegate
extension CharacterDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath.row)
    }

}

//MARK: - TableView's dataSource
extension CharacterDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id: String = presenter.dequeueID(row: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? TableViewDequeueable else { return UITableViewCell() }
        presenter.configure(cell: cell, row: indexPath.row)
        return cell
    }
}
