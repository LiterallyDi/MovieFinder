//
//  ErrorView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 08.09.25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    var onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.red)
            Text(message).multilineTextAlignment(.center)
            Button("Retry") {
                UINotificationFeedbackGenerator()
                    .notificationOccurred(.warning)
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(20)
        .background(
            .thinMaterial,
            in: RoundedRectangle(
                cornerRadius: 14,
                style: .continuous
            )
        )
        .padding()
    }
}
