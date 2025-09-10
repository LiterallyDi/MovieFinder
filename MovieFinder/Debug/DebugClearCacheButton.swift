//
//  DebugClearCacheButton.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import SwiftUI

#if DEBUG
struct DebugClearCacheButton: View {
    let onClear: () -> Void
    var body: some View {
        Button("Clear caches") { onClear() }
    }
}
#endif
