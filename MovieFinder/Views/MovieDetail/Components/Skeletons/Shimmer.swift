//
//  Shimmer.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -200

    func body(content: Content) -> some View {
        content
            .overlay {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .white.opacity(0.35),
                        .clear,
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .offset(x: phase)
                .blendMode(.plusLighter)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            }
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.2)
                    .repeatForever(autoreverses: false))
                {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmer() -> some View { modifier(Shimmer()) }
}
