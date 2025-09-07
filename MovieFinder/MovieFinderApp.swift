//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    init() {
        Task {
            await fetchPopular()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func fetchPopular() async {
    do {
        let service = DefaultNetworkService(
            baseURL: Constants.baseURL,
            readToken: Config.tmdbReadToken
        )

        let endpoint = Endpoint(path: "movie/popular")
        let response: MovieResponse = try await service.request(endpoint)
        print("Fetched movies:", response.results.count)
    } catch {
        print("Error fetching movies:", error)
    }
}
