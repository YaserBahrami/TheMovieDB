//
//  MainCoordinator.swift
//  TheMovieDB
//
//  Created by Yaser on 12.01.2025.
//

import UIKit

class AppCoordinator: Coordinator {
    private let window: UIWindow
        private let networkManager: NetworkManagerProtocol

    init(window: UIWindow, networkManager: NetworkManagerProtocol) {
        self.window = window
        self.networkManager = networkManager
    }
    
    func start() {
        showMovieList()
    }
    
    func showMovieList() {
        let movieListCoordinator = MovieListCoordinator(window: window, networkManager: networkManager)
        movieListCoordinator.start()
    }
}
