//
//  CharacterDetailsViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharacterDetailsView: AnyObject {
    func reloadTableView()
    func reloadTableView(indexPath: IndexPath)
    func startLoader()
    func stopLoader()
    func showErrorMessage(_ text: String)
}

///  Controller for details of selected character.
///  Here we show more iformation about the character, related episodes and other characters in those episodes.
final class CharacterDetailsViewController: UIViewController {
    
    //MARK: Properties
    var presenter: CharacterDetailsPresenter!
    private var errorTimer: Timer?
    
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
    
    private let errorMessage: ErrorMessageView = {
        let view = ErrorMessageView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Character Details"
        setupUI()
        
        presenter.viewDidLoad()
    }
    
    deinit {
        errorTimer?.invalidate()
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
    
    func reloadTableView(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func startLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.loaderIndicator.startAnimating()
        }
    }
    
    func stopLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = true
            self?.loaderIndicator.stopAnimating()
        }
    }
    
    func showErrorMessage(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage.configure(withMessage: text)
            self?.errorMessage.isHidden = false
            self?.errorTimer = .scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                self?.errorMessage.isHidden = true
                self?.errorTimer?.invalidate()
            })
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
        presenter.didSelectRow(at: indexPath)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollViewDidReachEnd(scrollView: scrollView) {
            presenter.didScrollToBottom()
        }
    }

    private func scrollViewDidReachEnd(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y > scrollView.contentSize.height - 100 - scrollView.bounds.size.height
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
