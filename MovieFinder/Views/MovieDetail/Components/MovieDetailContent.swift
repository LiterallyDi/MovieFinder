//
//  MovieDetailContent.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI

struct MovieDetailContent: View {
    let movie: Movie
    var trailers: [MovieVideo] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                PosterImageView(path: movie.posterPath)
                    .frame(height: 320)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                Text(movie.title)
                    .font(.title.bold())
                    .lineLimit(3)

                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                    Text(String(format: "%.1f", movie.voteAverage))
                    if let date = movie.releaseDate, !date.isEmpty {
                        Text("· \(date)")
                    }
                }
                .foregroundStyle(.secondary)

                if !movie.overview.isEmpty {
                    Text(movie.overview)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                // MARK: - trailer

                TrailersRow(trailers: trailers)
                    .padding(.top, 8)
                    
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
