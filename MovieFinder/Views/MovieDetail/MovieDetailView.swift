//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var vm: MovieDetailViewModel

    init(movieID: Int, repository: MovieRepository? = nil) {
        let repo = repository ?? TMDBMovieRepository(
            service: DefaultNetworkService(
                baseURL: Constants.baseURL,
                readToken: Config.tmdbReadToken
            )
        )
        _vm = StateObject(wrappedValue: MovieDetailViewModel(id: movieID, repository: repo))
    }

    var body: some View {
        Group {
            if vm.isLoading {
                MovieDetailSkeleton()
            } else if let message = vm.error {
                ErrorView(message: message) { vm.retry() }
            } else if let m = vm.movie {
                MovieDetailContent(movie: m)
            } else {
                NoDataView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let m = vm.movie {
                ToolbarItem(placement: .topBarTrailing) {
                    FavoriteToggleButton(movie: m)
                }
            }
        }
        .onAppear {
            if vm.movie == nil && vm.isLoading == false {
                vm.load()
            }
        }
    }
}
