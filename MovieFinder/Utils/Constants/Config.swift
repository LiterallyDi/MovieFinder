//
//  Config.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Foundation

enum Config {
    static var tmdbReadToken: String {
        (Bundle.main.object(forInfoDictionaryKey: "TMDB_READ_TOKEN") as? String) ?? ""
    }
}

enum Constants {
    static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")!
}
