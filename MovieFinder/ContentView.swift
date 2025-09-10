//
//  ContentView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm: MovieListViewModel

    init(repository: MovieRepository) {
        _vm = StateObject(wrappedValue: MovieListViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            MovieListView(vm: vm)
                .navigationTitle("Movies")
        }
    }
}
