//
//  TrailersRow.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 13.09.25.
//

import SwiftUI

struct TrailersRow: View {
    let trailers: [MovieVideo]
    @State private var selected: IdentifiableURL?

    var body: some View {
        if trailers.isEmpty {
            EmptyView()
        } else {
            VStack {
                Text("Trailer")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(trailers) { t in
                        Button {
                            if let url = t.youtubeURL {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                selected = IdentifiableURL(url: url)
                            }
                        } label: {
                            VStack(alignment: .center, spacing: 6) {
                                CachedImage(url: t.youtubeThumbnail,
                                            contentMode: .fit,
                                            placeholderHeight: 100)

                                    .clipped()
                                    .clipShape(RoundedRectangle(
                                        cornerRadius: 10,
                                        style: .continuous
                                    ))
                                    .overlay(alignment: .center) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 40, weight: .semibold))
                                            .foregroundStyle(.white.opacity(0.9))
                                            .shadow(radius: 4)
                                    }
                                Text(t.name)
                                    .font(.caption)
                                    .lineLimit(2)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
            .sheet(item: $selected) { item in
                SafariView(url: item.url)
                    .ignoresSafeArea()
            }
        }
    }
}

#if DEBUG

struct TrailersRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrailersRow(trailers: sampleTrailers)
                .padding()
                .previewDisplayName("Light")

            TrailersRow(trailers: sampleTrailers)
                .padding()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark")

            TrailersRow(trailers: [])
                .padding()
                .previewDisplayName("Empty")
        }
    }

    static let sampleTrailers: [MovieVideo] = [
        MovieVideo(
            id: "tr1",
            name: "Official Trailer",
            key: "dQw4w9WgXcQ",
            site: "YouTube",
            size: 1080,
            type: "Trailer",
            official: true,
            publishedAt: "2024-05-01T12:00:00.000Z",
            iso6391: "en",
            iso31661: "US"
        )
    ]
}
#endif
