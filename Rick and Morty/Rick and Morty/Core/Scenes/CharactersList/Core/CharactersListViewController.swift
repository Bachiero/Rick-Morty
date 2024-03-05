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
    func showErrorMessage(_ text: String)
}

/// Controller to show the list of characters
/// Including the search and filter to find the Schwifty
final class CharactersListViewController: UIViewController {
    //MARK: Properties
    var presenter: CharactersListPresenter!
    
    private var errorTimer: Timer?
    
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
        bar.layer.cornerRadius = 16
        bar.placeholder = "Search..."
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.tintColor = .systemOrange
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
    
    private let errorMessage: ErrorMessageView = {
        let view = ErrorMessageView()
        view.isHidden = true
        return view
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Characters"
        setupUI()
        presenter.fetchCharacters(searchKeyword: "")
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
        view.addSubview(searchBar)
        view.addSubview(errorMessage)
    }
    
    private func setupLayout() {
        let searchBarConstraints: [NSLayoutConstraint] = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        ]
        
        let tableViewConstraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let loaderConstraints: [NSLayoutConstraint] = [
            loaderIndicator.heightAnchor.constraint(equalToConstant: 60),
            loaderIndicator.widthAnchor.constraint(equalToConstant: 60),
            loaderIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let errorMessageConstraints: [NSLayoutConstraint] = [
            errorMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessage.centerYAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50)
        ]
        
        let constraints = [tableViewConstraints, loaderConstraints, searchBarConstraints, errorMessageConstraints]
        constraints.forEach { NSLayoutConstraint.activate($0)}
    }
    
    private func setupAppearence() {
        view.backgroundColor = Colors.RickDomColorPalette.purpleGrey
        searchBar.backgroundColor = Colors.RickDomColorPalette.regularGrey
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = Colors.RickDomColorPalette.white
        searchBar.searchTextField.textColor = Colors.RickDomColorPalette.white
        tableView.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func hideErrorMessage() {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage.isHidden = true
            self?.errorTimer?.invalidate()
        }
    }
    
    @objc func tableViewDidRefresh() {
        tableView.refreshControl?.endRefreshing()
        searchBar.searchTextField.text = nil
        presenter.fetchCharacters(searchKeyword: nil)
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
        DispatchQueue.main.async { [weak self] in
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

//MARK: - TableView's delegate
extension CharactersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCharacter(at: indexPath.row)
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
        presenter.fetchCharacters(searchKeyword: searchBar.searchTextField.text)
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 1 {
            presenter.fetchCharacters(searchKeyword: nil)
            hideErrorMessage()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
        searchBar.searchTextField.text = ""
        presenter.fetchCharacters(searchKeyword: searchBar.searchTextField.text)
        hideErrorMessage()
    }
}
