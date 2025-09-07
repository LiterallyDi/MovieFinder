//
//  Endpoints.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Foundation

struct Endpoint {
    var path: String
    var method: HTTPMethod = .GET
    var query: [URLQueryItem] = []
}
