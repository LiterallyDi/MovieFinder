//
//  AppCache.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import SwiftUI

enum AppCache {
    static func clearAll() {
        URLCache.shared.removeAllCachedResponses()

        UserDefaultsMovieCache().clearPopularPage1()
//         ImageCache.shared.removeAll()
    }
}

