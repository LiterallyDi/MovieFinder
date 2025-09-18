//
//  LoadingView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI
import UIKit

struct LoadingView: View {
    @State private var rotating = false
    var title: String = "Loading…"

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.fill")
                .font(.system(size: 32, weight: .semibold))
                .rotationEffect(.degrees(rotating ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: rotating)
                .onAppear { rotating = true }
            Text(title).foregroundStyle(.secondary).font(.headline)
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .onAppear {
            UIImpactFeedbackGenerator(style: .light)
                .impactOccurred()
        }
    }
}
