//
//  MovieListCoordinator.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit

class MovieListCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let movieListViewModel = MovieListViewModel(repository: MovieRepository(networkManager: NetworkManager()))
        let movieListVC = MovieListViewController(viewModel: movieListViewModel)
        movieListVC.onMovieSelected = { [weak self] movie in
            self?.showMovieDetails(for: movie)
        }
        navigationController.pushViewController(movieListVC, animated: true)
    }
    
    private func showMovieDetails(for movie: Movie) {
        let movieDetailsViewModel = MovieDetailsViewModel(movie: movie)
        let movieDetailsVC = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        navigationController.pushViewController(movieDetailsVC, animated: true)
    }
}
