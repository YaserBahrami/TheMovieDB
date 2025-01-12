//
//  MainCoordinator.swift
//  TheMovieDB
//
//  Created by Yaser on 12.01.2025.
//

import UIKit

class MainCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMovieList()
    }
    
    func showMovieList() {
        let movieListCoordinator = MovieListCoordinator(navigationController: navigationController)
        movieListCoordinator.start()
    }
}
