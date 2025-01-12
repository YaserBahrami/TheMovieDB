//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit
import SnapKit
import Combine

import UIKit
import Combine

class MovieListViewController: UIViewController {
    private let viewModel: MovieListViewModel
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>() // Add this property
    var onMovieSelected: ((Movie) -> Void)?

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
        viewModel.fetchMovies()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func bindViewModel() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let movie = viewModel.movies[indexPath.row]
        print("//////")
        print(movie)
        cell.textLabel?.text = movie.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        onMovieSelected?(movie)
    }
}
