//
//  TMDBMovieRepository.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Combine
import Foundation

struct TMDBMovieRepository: MovieRepository {
    private let service: NetworkService
    init(service: NetworkService) { self.service = service }

    func fetchPopular(page: Int) -> AnyPublisher<MovieResponse, APIError> {
        service.request(Endpoint(path: "movie/popular",
                                 method: .GET,
                                 query: [
                                     URLQueryItem(name: "page", value: "\(page)"),
                                     URLQueryItem(name: "language", value: "en-US")
                                 ]))
    }

    func search(query: String, page: Int) -> AnyPublisher<MovieResponse, APIError> {
        service.request(Endpoint(path: "search/movie",
                                 method: .GET,
                                 query: [
                                     URLQueryItem(name: "query", value: query),
                                     URLQueryItem(name: "page", value: "\(page)"),
                                     URLQueryItem(name: "include_adult", value: "false"),
                                     URLQueryItem(name: "language", value: "en-US")
                                 ]))
    }

    func details(id: Int) -> AnyPublisher<Movie, APIError> {
        service.request(Endpoint(path: "movie/\(id)",
                                 method: .GET,
                                 query: [URLQueryItem(name: "language", value: "en-US")]))
    }

    func videos(id: Int) -> AnyPublisher<MovieVideoResponse, APIError> {
        service.request(Endpoint(
            path: "movie/\(id)/videos",
            method: .GET,
            query: [
                URLQueryItem(name: "language", value: "en-US")
            ]
        ))
    }
}
