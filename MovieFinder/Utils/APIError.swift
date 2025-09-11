//
//  APIError.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Foundation

struct TMDBErrorBody: Codable {
    let status_code: Int?
    let status_message: String?
    let success: Bool?
}

enum APIError: LocalizedError {
    case transport(URLError)
    case http(status: Int, message: String?)
    case decoding(DecodingError)
    case invalidURL
    case missingAPIKey
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .transport(let e):
            if e.code == .notConnectedToInternet { return "No internet connection." }
            return "Network error. Please try again."
        case .http(let status, let msg):
            switch status {
            case 401: return "Unauthorized. Check your API token."
            case 404: return "Not found."
            case 429: return "Rate limit exceeded. Please wait a bit."
            default: return msg ?? "Server error (\(status))."
            }
        case .decoding: return "Failed to parse data."
        case .invalidURL: return "Internal error: invalid URL."
        case .missingAPIKey: return "Missing API token."
        case .timeout: return "Request timed out."
        case .unknown: return "Unexpected error."
        }
    }
}
