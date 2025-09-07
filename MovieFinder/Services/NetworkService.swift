//
//  NetworkService.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct DefaultNetworkService: NetworkService {
    private let baseURL: URL
    private let readToken: String
    private let session: URLSession = .shared
    private let decoder = JSONDecoder()
    
    init(baseURL: URL, readToken: String) {
        self.baseURL = baseURL
        self.readToken = readToken
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        guard !readToken.isEmpty else { throw APIError.missingAPIKey }
        
        var comps = URLComponents(url: baseURL.appendingPathComponent(endpoint.path),
                                  resolvingAgainstBaseURL: false)
        comps?.queryItems = endpoint.query.isEmpty ? nil : endpoint.query
        guard let url = comps?.url else { throw APIError.invalidURL }
        
        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(readToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else {
                throw APIError.transport(URLError(.badServerResponse))
            }
            
            print("\(req.httpMethod ?? "GET") \(req.url?.absoluteString ?? "")")
            print("Auth header present:", req.value(forHTTPHeaderField: "Authorization") != nil)
            if let auth = req.value(forHTTPHeaderField: "Authorization") {
                print("Authorization:", String(auth.prefix(20)) + "…")
            }
            print("status:", http.statusCode)
            if let text = String(data: data, encoding: .utf8) { print("Body:", text) }
            
            guard (200 ... 299).contains(http.statusCode) else {
                throw APIError.http(status: http.statusCode, body: data)
            }
            
            return try decoder.decode(T.self, from: data)
            
        } catch {
            if let e = error as? APIError { throw e }
            if error is DecodingError { throw APIError.decoding(error) }
            throw APIError.transport(error)
        }
    }
}
