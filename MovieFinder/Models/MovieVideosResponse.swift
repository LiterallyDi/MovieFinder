//
//  MovieVideosResponse.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 13.09.25.
//

import Foundation

struct MovieVideoResponse: Decodable {
    let id: Int
    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let key: String
    let site: String
    let size: Int?
    let type: String
    let official: Bool?
    let publishedAt: String? // ISO8601
    let iso6391: String?
    let iso31661: String?

    enum CodingKeys: String, CodingKey {
        case id, name, key, site, size, type, official
        case publishedAt = "published_at"
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
    }

    var youtubeURL: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var youtubeThumbnail: URL? {
        guard site.caseInsensitiveCompare("YouTube") == .orderedSame else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}
