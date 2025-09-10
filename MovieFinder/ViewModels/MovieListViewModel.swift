//
//  MovieListViewModel.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Combine
import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var query: String = ""

    @Published var newItemsPulse = 0

    private let repo: MovieRepository

    /// pagination
    private var page = 1
    private var hasMore = true
    private var searchPage = 1
    private var searchHasMore = true

    private var cancellables = Set<AnyCancellable>()
    private var currentRequest: AnyCancellable?
    private var seenIDs = Set<Int>()

    
    init(repository: MovieRepository) {
        self.repo = repository
        bindSearch()
    }

    func loadInitial() {
        guard movies.isEmpty else { return }
        fetchPopular(reset: true)
    }

    // MARK: - Popular

    func fetchPopular(reset: Bool = false) {
        if reset { resetListState() }
        guard hasMore, !isLoading else { return }

        currentRequest?.cancel()
        currentRequest = repo.fetchPopular(page: page)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
                self?.error = nil
            })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { [weak self] res in
                guard let self else { return }
                let unique = res.results.filter { self.seenIDs.insert($0.id).inserted }
                self.movies.append(contentsOf: unique)
                self.hasMore = self.page < res.totalPages
                self.page += 1
            }

        currentRequest?.store(in: &cancellables)
    }

    // MARK: - Search

    private func search(reset: Bool) {
        if reset { resetSearchState() }
        guard searchHasMore, !isLoading else { return }

        currentRequest?.cancel()
        currentRequest = repo.search(query: query, page: searchPage)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
                self?.error = nil
            })
            .receive(on: DispatchQueue.main) 
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.error = err.localizedDescription
                }
            } receiveValue: { [weak self] res in
                guard let self else { return }
                let unique = res.results.filter { self.seenIDs.insert($0.id).inserted }
                self.movies.append(contentsOf: unique)
                self.searchHasMore = self.searchPage < res.totalPages
                self.searchPage += 1
            }

        currentRequest?.store(in: &cancellables)
    }

    // MARK: - Helpers

    func loadMoreIfNeeded(_ movie: Movie) {
        guard let last = movies.last, last.id == movie.id else { return }
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fetchPopular(reset: false)
        } else {
            search(reset: false)
        }
    }

    func retry() {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fetchPopular(reset: true)
        } else {
            search(reset: true)
        }
    }

    private func bindSearch() {
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    self.fetchPopular(reset: true)
                } else {
                    self.search(reset: true)
                }
            }
            .store(in: &cancellables)
    }

    private func resetListState() {
        page = 1
        hasMore = true
        movies = []
        seenIDs.removeAll()
    }

    private func resetSearchState() {
        searchPage = 1
        searchHasMore = true
        movies = []
        seenIDs.removeAll()
    }
}
