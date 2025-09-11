//
//  FavoriteToggleButton.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftData
import SwiftUI

private func normalizePosterPath(_ path: String?) -> String? {
    guard var p = path, !p.isEmpty else { return nil }
    if !p.hasPrefix("/") { p = "/" + p }
    return p
}

struct FavoriteToggleButton: View {
    let movie: Movie
    @Environment(\.modelContext) private var context

    @Query private var existing: [FavoriteMovie]

    init(movie: Movie) {
        self.movie = movie
        _existing = Query(
            FetchDescriptor<FavoriteMovie>(
                predicate: #Predicate { $0.id == movie.id }
            ),
            animation: .default
        )
    }

    private var isFavorite: Bool { !existing.isEmpty }

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(isFavorite ? .red : .primary)
        }
    }

    private func toggle() {
        if let fav = existing.first {
            context.delete(fav)
        } else {
            let fav = FavoriteMovie(
                id: movie.id,
                title: movie.title,
                posterPath: normalizePosterPath(movie.posterPath),
                releaseDate: movie.releaseDate ?? "",
                voteAverage: movie.voteAverage
            )
            context.insert(fav)
        }
        try? context.save()
    }
}
