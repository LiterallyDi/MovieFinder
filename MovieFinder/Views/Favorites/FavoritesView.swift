//
//  FavoritesView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \FavoriteMovie.createdAt, order: .reverse) private var favorites: [FavoriteMovie]

    var body: some View {
        if favorites.isEmpty {
            ContentUnavailableView("No favorites yet",
                                   systemImage: "heart",
                                   description: Text("Add movies to favorites to see them here."))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            GeometryReader { proxy in
                let columns = Layout.gridColumns(for: proxy.size)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(favorites, id: \.persistentModelID) { fav in
                            NavigationLink {
                                MovieDetailView(movieID: fav.id)
                            } label: {
                                MovieCard(
                                    title: fav.title,
                                    rating: fav.voteAverage,
                                    releaseDate: fav.releaseDate,
                                    posterURL: ImageURLs.poster(fav.posterPath)
                                )
                            }

                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                }
            }

            .onAppear {
                var changed = false
                for fav in favorites {
                    if let p = fav.posterPath, !p.isEmpty, !p.hasPrefix("/") {
                        fav.posterPath = "/" + p
                        changed = true
                    }
                }
                if changed { try? context.save() }
            }
        }
    }
}

/// helper
private func posterURL(_ path: String?) -> URL? {
    guard var p = path, !p.isEmpty else { return nil }
    if !p.hasPrefix("/") { p = "/" + p }
    return URL(string: Constants.imageBaseURL.absoluteString + p)
}
