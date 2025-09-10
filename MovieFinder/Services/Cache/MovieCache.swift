//
//  MovieCache.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import Foundation

protocol MovieCache {
    func loadPopularPage1() -> MovieResponse?

    func savePopularPage1(_ response: MovieResponse)

    func clearPopularPage1()
}
