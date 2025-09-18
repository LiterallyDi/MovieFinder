//
//  SplashView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool
    @State private var angle: Double = 0

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            Image("LaunchLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .rotationEffect(.degrees(angle))
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        angle = 360
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        isActive = false
                    }
                }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading")
    }
}
