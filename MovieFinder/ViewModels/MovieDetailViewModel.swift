//
//  MovieDetailViewModel.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Combine
import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movie: Movie?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?

    private let repo: MovieRepository
    private let id: Int
    private var cancellables = Set<AnyCancellable>()

    init(id: Int, repository: MovieRepository) {
        self.id = id
        self.repo = repository
    }

    func load() {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        repo.details(id: id) 
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.error = (err as? LocalizedError)?.errorDescription ?? err.localizedDescription
                }
            } receiveValue: { [weak self] movie in
                self?.movie = movie
            }
            .store(in: &cancellables)
    }

    func retry() {
        load()
    }
}
