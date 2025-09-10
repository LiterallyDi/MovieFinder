//
//  ImageURLs.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Foundation

struct ImageURLs {
    static func poster(_ path: String?) -> URL? {
        guard let p = path else { return nil }
        return URL(string: Constants.imageBaseURL.absoluteString + p)
    }
}
