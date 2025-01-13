//
//  MovieListViewModel.swift
//  TheMovieDB
//
//  Created by Yaser on 13.01.2025.
//

import Foundation
import Combine

class MovieListViewModel {
    private let repository: MovieRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var isLoading = false
    
    @Published var movies: [Movie] = []
    @Published var errorMessage: String?
    
    private var searchQuery = PassthroughSubject<String, Never>()
    
    //    @Published var searchText: String = ""
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
        setupSearchListener()
        fetchPopularMovies()
    }
    
    func fetchPopularMovies() {
        repository.fetchPopularMovies(page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
    
    func searchMovies(query: String) {
        searchQuery.send(query)
    }
    
    private func setupSearchListener() {
        searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .userInteractive))
            .removeDuplicates()
            .sink { [weak self] query in
                guard !query.isEmpty else {
                    self?.fetchPopularMovies()
                    return
                }
                self?.repository.searchMovies(query: query, page: 1)
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            self?.errorMessage = error.localizedDescription
                        }
                    }, receiveValue: { movies in
                        self?.movies = movies
                    })
                    .store(in: &self!.cancellables)
            }
            .store(in: &cancellables)
    }
}
