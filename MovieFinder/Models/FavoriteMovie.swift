//
//  FavoriteMovie.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftData
import Foundation

@Model
final class FavoriteMovie {
    @Attribute(.unique) var id: Int // TMDB id 
    var title: String
    var posterPath: String?
    var releaseDate: String
    var voteAverage: Double
    var createdAt: Date

    init(id: Int, title: String, posterPath: String?, releaseDate: String, voteAverage: Double) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.createdAt = .now
    }
}
