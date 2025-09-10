//
//  CachedAsyncImage.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import Foundation
import SwiftUI
import UIKit

enum CachedAsyncPhase {
    case empty
    case success(UIImage)
    case failure
}

struct CachedAsyncImage<Placeholder: View, Failure: View, Content: View>: View {
    let url: URL?
    let placeholder: () -> Placeholder
    let failure: () -> Failure
    let content: (Image) -> Content

    @State private var phase: CachedAsyncPhase = .empty
    @State private var isLoading = false

    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failure: @escaping () -> Failure,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.url = url
        self.placeholder = placeholder
        self.failure = failure
        self.content = content
    }

    var body: some View {
        Group {
            switch phase {
            case .empty:
                placeholder()
                    .task { await loadIfNeeded() }
            case .failure:
                failure()
            case .success(let uiImg):
                content(Image(uiImage: uiImg))
            }
        }
    }

    @MainActor
    private func loadIfNeeded() async {
        guard !isLoading else { return }
        guard let url else {
            phase = .failure
            return
        }
        isLoading = true
        defer { isLoading = false }

        var req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)

        if let cached = URLCache.shared.cachedResponse(for: req),
           let img = UIImage(data: cached.data)
        {
            phase = .success(img)
            return
        }

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse, (200 ... 299).contains(http.statusCode),
               let img = UIImage(data: data)
            {
                let cached = CachedURLResponse(response: resp, data: data)
                URLCache.shared.storeCachedResponse(cached, for: req)
                phase = .success(img)
            } else {
                phase = .failure
            }
        } catch {
            phase = .failure
        }
    }
}
