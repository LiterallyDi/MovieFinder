//
//  Layout.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import SwiftUI

enum Layout {
    static func gridColumns(for size: CGSize) -> [GridItem] {
        let isWide = size.width >= 500
        let count = isWide ? 3 : 2
        return Array(
            repeating: GridItem(
                .flexible(),
                spacing: 12),
            count: count)
    }
}
