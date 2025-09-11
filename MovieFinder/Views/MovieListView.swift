//
//  MovieListView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var vm: MovieListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 12) {
            SearchBar(text: $vm.query, placeholder: "Search movies")

            if vm.isLoading && vm.movies.isEmpty {
                GeometryReader { proxy in
                    let columns = Layout.gridColumns(for: proxy.size)
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(0 ..< 8, id: \.self) { _ in
                                MovieCardSkeleton()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                }

            } else if let message = vm.error, vm.movies.isEmpty {
                ErrorView(message: message) { vm.retry() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            } else if vm.movies.isEmpty {
                NoDataView()

            } else {
                GeometryReader { proxy in
                    let columns = Layout.gridColumns(for: proxy.size)

                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(vm.movies) { movie in
                                NavigationLink {
                                    MovieDetailView(movieID: movie.id)
                                } label: {
                                    MovieCard(movie: movie)
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    if vm.movies.last?.id == movie.id {
                                        vm.loadMoreIfNeeded(movie)
                                    }
                                }
                            }

                            if vm.isLoading {
                                ProgressView()
                                    .padding(.vertical, 12)
                                    .gridCellColumns(columns.count)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 12)
                    }
                }

                .refreshable { vm.retry() }
                .sensoryFeedback(.impact(weight: .light),
                                 trigger: vm.newItemsPulse)
            }
        }

        .padding(.top, 12)
        .animation(.easeInOut(duration: 0.2), value: vm.movies)
        .onAppear { vm.loadInitial() }
        .sensoryFeedback(.impact(weight: .medium), trigger: vm.movies.count)
    }
}
