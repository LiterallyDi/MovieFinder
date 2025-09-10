//
//  UserDefaultsMovieCache.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import Foundation

private struct Cached<T: Codable>: Codable {
    let timestamp: Date
    let value: T
}

final class UserDefaultsMovieCache: MovieCache {
    private let defaults: UserDefaults
    private let key = "popular_page1_v1"
    private let ttl: TimeInterval // in secods

    init(defaults: UserDefaults = .standard, ttl: TimeInterval = 30 * 60) {
        self.defaults = defaults
        self.ttl = ttl
    }

    func loadPopularPage1() -> MovieResponse? {
        guard let data = defaults.data(forKey: key) else { return nil }
        do {
            let box = try JSONDecoder().decode(Cached<MovieResponse>.self, from: data)

            if Date().timeIntervalSince(box.timestamp) < ttl {
                return box.value
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    func savePopularPage1(_ response: MovieResponse) {
        let box = Cached(timestamp: Date(), value: response)
        if let data = try? JSONEncoder().encode(box) {
            defaults.set(data, forKey: key)
        }
    }

    func clearPopularPage1() {
        defaults.removeObject(forKey: key)
    }
}
