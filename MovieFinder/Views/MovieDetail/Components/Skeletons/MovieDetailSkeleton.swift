//
//  MovieDetailSkeleton.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct MovieDetailSkeleton: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(.secondary.opacity(0.25))
                    .frame(height: 320)
                    .shimmer()
                    .redacted(reason: .placeholder)

                RoundedRectangle(cornerRadius: 6).fill(.secondary.opacity(0.25))
                    .frame(height: 22)
                    .redacted(reason: .placeholder)

                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4).fill(.secondary.opacity(0.25))
                        .frame(width: 60, height: 14)
                    RoundedRectangle(cornerRadius: 4).fill(.secondary.opacity(0.2))
                        .frame(width: 90, height: 14)
                }
                .redacted(reason: .placeholder)

                ForEach(0 ..< 4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 6).fill(.secondary.opacity(0.2))
                        .frame(height: 12)
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .accessibilityHidden(true)
    }
}
