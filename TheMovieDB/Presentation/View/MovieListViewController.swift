//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit
import SnapKit
import Combine

class MovieListViewController: UIViewController {
    private let viewModel: MovieListViewModel
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    var onMovieSelected: ((Movie) -> Void)?
    
    private var filteredMovies: [Movie] = []
    private let searchBar = UISearchBar()
    private var searchQuery = ""
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupKeyboardDismissal()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
    }
    
    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$searchedMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.searchedMovies.count : viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.isSearching ? viewModel.searchedMovies[indexPath.row] : viewModel.movies[indexPath.row]
        
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.isSearching ? viewModel.searchedMovies[indexPath.row] : viewModel.movies[indexPath.row]
        
        onMovieSelected?(movie)
    }
}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100
        
        guard scrollView.contentOffset.y + scrollView.frame.size.height + threshold >= scrollView.contentSize.height else {
            return
        }
        
        if !viewModel.isSearching {
            viewModel.fetchPopularMovies()
        } else {
            return
        }
    }
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
        viewModel.searchMovies(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchQuery = ""
        viewModel.clearSearch()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}
