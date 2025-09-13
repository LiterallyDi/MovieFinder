//
//  ContentView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 07.09.25.
//

import SwiftUI

struct ContentView: View {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    var body: some View {
        AppTabView(repository: repository)
    }
}
