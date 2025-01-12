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
    @Published var searchText: String = ""

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
        bindSearch()
    }

    func fetchMovies() {
        guard !isLoading else { return }
        isLoading = true
        repository.fetchPopularMovies(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching movies: \(error)")
                }
            }, receiveValue: { [weak self] movies in
                self?.movies.append(contentsOf: movies)
                self?.currentPage += 1
            })
            .store(in: &cancellables)
    }

    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.movies = []
                    self.currentPage = 1
                    self.fetchMovies()
                } else {
                    self.searchMovies(query: query)
                }
            }
            .store(in: &cancellables)
    }

    private func searchMovies(query: String) {
        repository.searchMovies(query: query, page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error searching movies: \(error)")
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
            })
            .store(in: &cancellables)
    }
}

