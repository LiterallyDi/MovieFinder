//
//  AppTabView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct AppTabView: View {
    enum Tab: Hashable { case movies, favorites, profile }

    @State private var selection: Tab = .movies

    private let repository: MovieRepository
    @StateObject private var moviesVM: MovieListViewModel

    init(repository: MovieRepository) {
        self.repository = repository
        _moviesVM = StateObject(wrappedValue: MovieListViewModel(repository: repository))
    }

    var body: some View {
        TabView(selection: $selection) {
            // Movies
            NavigationStack {
                MovieListView(vm: moviesVM)
                    .navigationTitle("Movies")
            }
            .tabItem { Label("Movies", systemImage: "film.fill") }
            .tag(Tab.movies)

            // Favorites
            NavigationStack {
                FavoritesView()
                    .navigationTitle("Favorites")
            }
            .tabItem { Label("Favorites", systemImage: "heart.fill") }
            .tag(Tab.favorites)

            // Profile/Settings
            NavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .tabItem { Label("Profile", systemImage: "person.crop.circle") }
            .tag(Tab.profile)
        }
        .onChange(of: selection) {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
}
