//
//  ImageLoader.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import UIKit

actor ImageLoader {
    static let shared = ImageLoader()

    private var tasks: [URL: Task<UIImage?, Never>] = [:]

    func load(_ url: URL) -> UIImage? {
        if let img = ImageCache.shared.image(for: url) { return img }
        return nil
    }

    func fetch(_ url: URL) async -> UIImage? {
        if let img = ImageCache.shared.image(for: url) { return img }

        if let existing = tasks[url] { return await existing.value }

        let task = Task<UIImage?, Never> {
            defer { Task { await self.clear(url) } }
            var request = URLRequest(url: url)
            request.timeoutInterval = 30
            request.cachePolicy = .returnCacheDataElseLoad
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode),
                      let img = UIImage(data: data) else { return nil }
                ImageCache.shared.set(img, for: url)
                return img
            } catch {
                return nil
            }
        }

        tasks[url] = task
        return await task.value
    }

    private func clear(_ url: URL) {
        tasks[url] = nil
    }
}
