//
//  MovieCardSkeleton.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import Foundation
import SwiftUI

struct MovieCardSkeleton: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.secondary.opacity(0.25))
                .frame(height: 240)
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(.secondary.opacity(0.1)) }
                .shimmer()

            LinearGradient(colors: [.clear, .black.opacity(0.7)],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .allowsHitTesting(false)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 6).fill(.white.opacity(0.25))
                    .frame(height: 16)
                RoundedRectangle(cornerRadius: 6).fill(.white.opacity(0.2))
                    .frame(width: 80, height: 12)
            }
            .padding(12)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
        }
        .redacted(reason: .placeholder)
        .accessibilityHidden(true)
    }
}
