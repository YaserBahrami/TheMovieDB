//
//  MovieListCoordinator.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import UIKit

class MovieListCoordinator: Coordinator {
    private let window: UIWindow
        private let networkManager: NetworkManagerProtocol

        init(window: UIWindow, networkManager: NetworkManagerProtocol) {
            self.window = window
            self.networkManager = networkManager
        }
    
    func start() {
        let movieRepository = MovieRepository(networkManager: networkManager)
        let movieListViewModel = MovieListViewModel(repository: movieRepository)
        let movieListViewController = MovieListViewController(viewModel: movieListViewModel)
        
        movieListViewController.onMovieSelected = { [weak self] movie in
            self?.showMovieDetails(for: movie)
        }
        let navigationController = UINavigationController(rootViewController: movieListViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showMovieDetails(for movie: Movie) {
        let movieDetailsViewModel = MovieDetailsViewModel(movie: movie)
        let movieDetailViewController = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(movieDetailViewController, animated: true)
        }
    }
}
