//
//  NoDataView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import SwiftUI

struct NoDataView: View {
    var body: some View {
        ContentUnavailableView("No Data", systemImage: "film")
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
    }
}
