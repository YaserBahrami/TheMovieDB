//
//  MovieRepositoryProtocol.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Combine

protocol MovieRepositoryProtocol {
    func fetchPopularMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func searchMovies(query: String, page: Int) -> AnyPublisher<[Movie], Error>
}
