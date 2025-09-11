//
//  CachedImage.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct CachedImage: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    var placeholderHeight: CGFloat? = nil

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let ui = image {
                Image(uiImage: ui)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity)
            } else {
                ZStack {
                    Rectangle().fill(.quaternary)
                    ProgressView()
                }
                .frame(height: placeholderHeight)
            }
        }
        .id(url?.absoluteString ?? "nil")
        .task(id: url?.absoluteString) {
            guard let url else { return }
            if let cached = await ImageLoader.shared.load(url) {
                image = cached
                return
            }
            if !isLoading {
                isLoading = true
                let fetched = await ImageLoader.shared.fetch(url)
                await MainActor.run {
                    image = fetched
                    isLoading = false
                }
            }
        }
    }
}
