//
//  SearchMoviesUseCase.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Combine

protocol SearchMoviesUseCaseProtocol {
    func execute(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}


class SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func execute(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        movieRepository.searchMovies(query: query, page: page)
            .sink(receiveCompletion: { completionResult in
                switch completionResult {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { movies in
                completion(.success(movies))
            })
            .store(in: &cancellables)
    }
}
