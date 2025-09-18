//
//  ImageURLs.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Foundation

enum ImageURLs {
    /// TMDB poster url from an optional path.
    static func poster(_ path: String?) -> URL? {
        guard var p = path, !p.isEmpty else { return nil }
        if !p.hasPrefix("/") { p = "/" + p }

        return URL(string: Constants.imageBaseURL.absoluteString + p)
    }
}
