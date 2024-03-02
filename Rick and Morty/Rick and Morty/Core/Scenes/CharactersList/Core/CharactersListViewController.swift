//
//  CharactersListViewController.swift
//  Rick and Morty
//
//  Created by Bachuki Bitsadze on 29.02.24.
//

import UIKit

protocol CharactersListView: AnyObject {
    func reloadTableView()
    func startLoader()
    func stopLoader()
}


/// Controller to show the list of characters
/// Including the search and filter to find the Schwifty
final class CharactersListViewController: UIViewController {
    //MARK: Properties
    var presenter: CharactersListPresenter!
    
    private let screenTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.showsCancelButton = true
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(tableViewDidRefresh), for: .valueChanged)
        table.register(CharactersListTableViewCell.self, forCellReuseIdentifier: CharactersListTableViewCell.identifier)
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
        navigationItem.title = "Characters"
        setupUI()
        presenter.fetchCharacters(searchKeyword: "")
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        
        let loaderConstraints: [NSLayoutConstraint] = [
            loaderIndicator.heightAnchor.constraint(equalToConstant: 60),
            loaderIndicator.widthAnchor.constraint(equalToConstant: 60),
            loaderIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(tableViewConstraints)
        NSLayoutConstraint.activate(loaderConstraints)
    }
    
    private func setupAppearence() {
        view.backgroundColor = .systemGray4
        tableView.backgroundColor = .clear
    }
    
    //MARK: -
    @objc func tableViewDidRefresh() {
        //FIXME: handle tv refresh
//        tableView.refreshControl?.endRefreshing()
//        searchBar.searchTextField.text = nil
//        presenter.fetchCharacters(for: nil)
//        stopLoader()
    }
    
}

//MARK: - View interface conformance
extension CharactersListViewController: CharactersListView {
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
        loaderIndicator.stopAnimating()
    }
    
}

//MARK: - TableView's delegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
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
extension CharactersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: CharactersListTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CharactersListTableViewCell
        cell?.configure(with: presenter.getTableViewCellModel(for: indexPath.row))
        return cell ?? UITableViewCell()
    }
}

//MARK: - UISearchBarDelegate
extension CharactersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //FIXME: handle search
//        presenter.fetchCharacters(for: searchBar.searchTextField.text)
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 1 {
            //FIXME: reset list
//            presenter.fetchCharacters(for: nil)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //FIXME: handle cancel button
//        presenter.fetchCharacters(for: searchBar.searchTextField.text)
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
    }
}
