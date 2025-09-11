//
//  ProfileView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import SwiftUI

struct ProfileView: View {
    private var appVersion: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "–"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "–"
        return "\(v) (\(b))"
    }

    var body: some View {
        List {
            Section("App") {
                LabeledContent("Version", value: appVersion)
                LabeledContent("Build", value: Bundle.main.bundleIdentifier ?? "–")
            }
            Section("About") {
                Text("MovieFinder — demo app\nSwiftUI + Combine + MVVM")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
    }
}
