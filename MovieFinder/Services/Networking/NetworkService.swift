//
//  NetworkService.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Combine
import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError>
}

struct DefaultNetworkService: NetworkService {
    private let baseURL: URL
    private let readToken: String
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(baseURL: URL, readToken: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.readToken = readToken
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard !readToken.isEmpty else {
            return Fail(error: .missingAPIKey).eraseToAnyPublisher()
        }

        var comps = URLComponents(url: baseURL.appendingPathComponent(endpoint.path),
                                  resolvingAgainstBaseURL: false)
        comps?.queryItems = endpoint.query.isEmpty ? nil : endpoint.query
        guard let url = comps?.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(readToken)", forHTTPHeaderField: "Authorization")

        return session.dataTaskPublisher(for: req)
            .tryMap { data, response -> Data in
                guard let http = response as? HTTPURLResponse else {
                    throw APIError.transport(URLError(.badServerResponse))
                }
                guard (200 ... 299).contains(http.statusCode) else {
                    throw APIError.http(status: http.statusCode, body: data)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { err in
                if let api = err as? APIError { return api }
                if err is DecodingError { return .decoding(err) }
                if let urlErr = err as? URLError { return .transport(urlErr) }
                return .transport(err)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
