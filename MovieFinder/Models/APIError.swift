//
//  APIError.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case missingAPIKey
    case transport(Error)
    case http(status: Int, body: Data?)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .missingAPIKey: return "TMDB API key is missing"
        case .transport(let e): return "Network error: \(e.localizedDescription)"
        case .http(let s, _): return "Server error (\(s))"
        case .decoding: return "Failed to parse response"
        }
    }
}
