//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import SwiftUI

@main
struct MovieFinderApp: App {
    @State private var showSplash = true

    private let repository: MovieRepository = {
        let service = DefaultNetworkService(
            baseURL: Constants.baseURL,
            readToken: Config.tmdbReadToken
        )
        return TMDBMovieRepository(service: service)
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView(isActive: $showSplash)
                } else {
                    NavigationStack {
                        ContentView(repository: repository)
                    }
                }
            }
        }
    }
}
