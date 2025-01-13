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
    @Published var searchedMovies: [Movie] = []
    @Published var errorMessage: String?
    @Published var isSearching = false
    
    
    private var searchQuery = PassthroughSubject<String, Never>()
    
    
    init(fetchPopularMoviesUseCase: FetchPopularMoviesUseCaseProtocol, searchMoviesUseCase: SearchMoviesUseCaseProtocol) {
        self.fetchPopularMoviesUseCase = fetchPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
        
        fetchPopularMovies()
        setupSearchListener()
    }
    
    func fetchPopularMovies() {
        
        guard !isLoading else { return }
        isLoading = true
        
        
        fetchPopularMoviesUseCase.execute(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newMovies):
                    self?.movies.append(contentsOf: newMovies)
                    self?.currentPage += 1
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func searchMovies(query: String) {
        
        if query.isEmpty {
            clearSearch()
        } else {
            isSearching = true
            searchedMovies = []
            searchQuery.send(query)
        }
    }
    
    func clearSearch() {
        isSearching = false
        searchedMovies = []
        fetchPopularMovies()
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
        print("Handle Search Query: \(query)")
        if query.isEmpty {
            clearSearch()
        } else {
            isLoading = true
            searchMoviesUseCase.execute(query: query, page: 1) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.handleResult(result)
                }
            }
        }
    }
    
    private func handleResult(_ result: Result<[Movie], Error>) {
        switch result {
        case .success(let newMovies):
            if !newMovies.isEmpty {
                self.searchedMovies.append(contentsOf: newMovies)
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
}
