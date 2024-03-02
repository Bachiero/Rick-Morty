//
//  CharacterDetailsViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharacterDetailsView: AnyObject {
    func setupImage(_ image: UIImage)
    func reloadTableView()
    func startLoader()
    func stopLoader()
    func setupDetailsStack(with details: [String])
}

///  Controller for details of selected character.
///  Here we show more iformation about the character, related episodes and other characters in those episodes.
final class CharacterDetailsViewController: UIViewController {
    
    //MARK: Properties
    var presenter: CharacterDetailsPresenter!
    
    private let characterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        return image
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.layer.cornerRadius = 16
        stack.layoutMargins = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: .zero)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    //FIXME: Move character image and detailsStack to tableView cells and configure the page with tv only.
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CharactersListTableViewCell.self, forCellReuseIdentifier: CharactersListTableViewCell.identifier)
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
        view.addSubview(characterImage)
        view.addSubview(detailsStack)
        view.addSubview(tableView)
        view.addSubview(loaderIndicator)
    }
    
    private func setupLayout() {
        let characterImageConstraints: [NSLayoutConstraint] = [
            characterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImage.heightAnchor.constraint(equalToConstant: 300),
            characterImage.widthAnchor.constraint(equalToConstant: 300),
            characterImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
         let detailsStackeConstraints: [NSLayoutConstraint] = [
            detailsStack.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: -60),
            detailsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsStack.heightAnchor.constraint(equalToConstant: 130),
            detailsStack.widthAnchor.constraint(equalToConstant: 240)
        ]
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 8),
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
        
        let constraints = [characterImageConstraints, detailsStackeConstraints, tableViewConstraints, loaderConstraints]
        constraints.forEach { NSLayoutConstraint.activate($0)}
    }
    
    private func setupAppearence() {
        view.backgroundColor = Colors.RickDomColorPalette.purpleGrey
        detailsStack.backgroundColor = Colors.RickDomColorPalette.darkGrey
        detailsStack.alpha = 0.7
        tableView.backgroundColor = Colors.RickDomColorPalette.lightGrey
    }
    
    
    
}

//MARK: - View interface conformance
extension CharacterDetailsViewController: CharacterDetailsView {
    func setupImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.characterImage.image = image
        }
    }
    
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
    
    func setupDetailsStack(with details: [String]) {
        details.forEach {
            let label = getDetailsLabel()
            label.text = $0
            detailsStack.addArrangedSubview(label)
        }
    }
}

//MARK: - Private methods
extension CharacterDetailsViewController {
    private func getDetailsLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        label.alpha = 1
        return label
    }
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
        presenter.didSelectEpisode(at: indexPath.row)
    }

}

//MARK: - TableView's dataSource
extension CharacterDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: CharactersListTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CharactersListTableViewCell
        cell?.configure(with: presenter.getTableViewCellModel(for: indexPath.row))
        return cell ?? UITableViewCell()
    }
}
