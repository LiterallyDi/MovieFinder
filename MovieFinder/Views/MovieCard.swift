//
//  MovieCard.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI

struct MovieCard: View {
    let title: String
    let rating: Double
    let releaseDate: String
    let posterURL: URL?

    private var year: String {
        releaseDate.split(separator: "-").first.map(String.init) ?? ""
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(
                url: posterURL,
                placeholder: {
                    ZStack {
                        Rectangle().fill(.quaternary)
                        ProgressView()
                    }
                },
                failure: {
                    ZStack {
                        Rectangle().fill(.quaternary)
                        Image(systemName: "film").imageScale(.large)
                    }
                },
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }
            )

            .frame(height: 240)
            .background(Color(.secondarySystemBackground))
            .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .contentShape(Rectangle())
//            AsyncImage(url: posterURL) { phase in
//                switch phase {
//                case .empty:
//                    ZStack { Rectangle().fill(.quaternary); ProgressView() }
//                case .success(let img):
//                    img.resizable().scaledToFill()
//                        .transition(.opacity.combined(with: .scale(scale: 0.98)))
//                case .failure:
//                    ZStack { Rectangle().fill(.quaternary); Image(systemName: "film").imageScale(.large) }
//                @unknown default:
//                    Rectangle().fill(.quaternary)
//                }
//            }
            .frame(height: 240)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            LinearGradient(colors: [.clear, .black.opacity(0.8)],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: 110)
                .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    Label(String(format: "%.1f", rating), systemImage: "star.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.yellow)
                    Text(year)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(12)
        }
        .contentShape(Rectangle())
        .accessibilityLabel("\(title), rating \(String(format: "%.1f", rating)), year \(year)")
    }
}

extension MovieCard {
    init(movie: Movie) {
        self.init(
            title: movie.title,
            rating: movie.voteAverage,
            releaseDate: movie.releaseDate ?? "",
            posterURL: ImageURLs.poster(movie.posterPath)
        )
    }
}
