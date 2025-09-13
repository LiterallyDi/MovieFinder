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
    @Published private(set) var trailers: [MovieVideo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?

    private let repo: MovieRepository
    private let id: Int
    private var current: AnyCancellable?

    private let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    init(id: Int, repository: MovieRepository) {
        self.id = id
        self.repo = repository
    }

    func load() {
        current?.cancel()
        error = nil
        isLoading = true

        let details: AnyPublisher<Movie, APIError> = repo.details(id: id)
        let videos: AnyPublisher<MovieVideoResponse, APIError> = repo.videos(id: id)

        current = details
            .zip(videos)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = completion {
                    self.error = (err as? LocalizedError)?.errorDescription ?? err.localizedDescription
                }
            } receiveValue: { [weak self] movie, videoResponse in
                guard let self else { return }
                self.movie = movie

                func parsedDate(_ s: String?) -> Date {
                    s.flatMap { self.iso.date(from: $0) } ?? .distantPast
                }
                func isOfficial(_ v: MovieVideo) -> Bool {
                    (v.official ?? false) || v.name.lowercased().contains("official")
                }

                // youtube
                let youtube = videoResponse.results.filter {
                    $0.site.caseInsensitiveCompare("YouTube") == .orderedSame
                }
                // Trailer type
                let onlyTrailers = youtube.filter {
                    $0.type.caseInsensitiveCompare("Trailer") == .orderedSame
                }

                let prioritized = onlyTrailers.sorted { a, b in
                    switch (isOfficial(a), isOfficial(b)) {
                    case (true, false): return true
                    case (false, true): return false
                    default: break
                    }
                    let la = (a.iso6391?.lowercased() == "en") ? 0 : 1
                    let lb = (b.iso6391?.lowercased() == "en") ? 0 : 1
                    if la != lb { return la < lb }
                    let da = parsedDate(a.publishedAt)
                    let db = parsedDate(b.publishedAt)
                    if da != db { return da > db } // новее раньше
                    return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
                }

                // 1 trailer
                self.trailers = prioritized.first.map { [$0] } ?? []
            }
    }

    func retry() { load() }
}
