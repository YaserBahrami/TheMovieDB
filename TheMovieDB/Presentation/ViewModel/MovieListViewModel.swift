//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation
import Combine

class MovieListViewModel {
    private let fetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var isLoading = false
    
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    
    private var searchQuery = PassthroughSubject<String, Never>()
    
    
    init(fetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol, searchMoviesUseCase: SearchMoviesUseCaseProtocol) {
        self.fetchPopularMoviesUseCase = fetchPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
        
        fetchPopularMovies()
        setupSearchListener()
    }
    
    private func fetchPopularMovies() {
        fetchPopularMoviesUseCase.execute(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMovies):
                    self?.movies = newMovies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func searchMovies(query: String) {
        searchQuery.send(query)
    }
    
    private func setupSearchListener() {
        searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .userInteractive))
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                self.handleSearchQuery(query)
            }
            .store(in: &cancellables)
    }
    
    private func handleSearchQuery(_ query: String) {
        if query.isEmpty {
            fetchPopularMovies()
        } else {
            searchMoviesUseCase.execute(query: query, page: currentPage) { [weak self] result in
                DispatchQueue.main.async {
                    self?.handleResult(result)
                }
            }
        }
    }
    
    private func handleResult(_ result: Result<[Movie], Error>) {
        switch result {
        case .success(let newMovies):
            self.movies = newMovies
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
