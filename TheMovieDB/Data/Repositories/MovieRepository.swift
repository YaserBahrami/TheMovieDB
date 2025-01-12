//
//  MovieRepository.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Combine

class MovieRepository: MovieRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        networkManager.fetch(MovieResponse.self, Endpoint.popularMovies(page: page))
            .map(\.results) // Use keyPath for clarity
            .eraseToAnyPublisher()
    }

    func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], Error> {
        networkManager.fetch(MovieResponse.self, Endpoint.searchMovies(query: query, page: page))
            .map(\.results) // Use keyPath for clarity
            .eraseToAnyPublisher()
    }
}
