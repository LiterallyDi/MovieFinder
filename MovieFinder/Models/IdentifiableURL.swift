//
//  IdentifiableURL.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 13.09.25.
//

import Foundation

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
