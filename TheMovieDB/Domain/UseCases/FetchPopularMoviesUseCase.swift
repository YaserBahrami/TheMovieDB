//
//  FetchPopularMoviesUseCase.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Combine

protocol FetchPopularMoviesUseCaseProtocol {
    func execute(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}



class FetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol {
    private let movieRepository: MovieRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func execute(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        movieRepository.fetchPopularMovies(page: page)
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
