//
//  MainCoordinator.swift
//  TheMovieDB
//
//  Created by Yaser on 12.01.2025.
//

import UIKit

class MainCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let movieListVC = createMovieListViewController()
        navigationController.setViewControllers([movieListVC], animated: false)
    }
    
    private func createMovieListViewController() -> UIViewController {
        let viewModel = MovieListViewModel(repository: MovieRepository(networkManager: NetworkManager()))
        let viewController = MovieListViewController(viewModel: viewModel)
        viewModel.didSelectMovie = { [weak self] movie in
            self?.navigateToMovieDetails(movie: movie)
        }
        return viewController
    }
    
    private func navigateToMovieDetails(movie: Movie) {
        let viewModel = MovieDetailsViewModel(movie: movie)
        let detailsVC = MovieDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
