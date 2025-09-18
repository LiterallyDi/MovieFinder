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
            CachedImage(url: posterURL, contentMode: .fill, placeholderHeight: 240)
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
