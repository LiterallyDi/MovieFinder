//
//  MovieRepository.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import Combine

protocol MovieRepository {
    func fetchPopular(page: Int) -> AnyPublisher<MovieResponse, APIError>
    func search(query: String, page: Int) -> AnyPublisher<MovieResponse, APIError>
    func details(id: Int) -> AnyPublisher<Movie, APIError>
    
    func cachedPopularPage1() -> MovieResponse?

}
