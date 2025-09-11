//
//  ImageCache.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 11.09.25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let mem = NSCache<NSURL, UIImage>()
    private init() {
        mem.countLimit = 500
        mem.totalCostLimit = 128 * 1024 * 1024 
    }

    func image(for url: URL) -> UIImage? {
        mem.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let bpp = image.cgImage?.bitsPerPixel ?? 32 /// bits per pixel
        let bytesPerPixel = bpp / 8

        let cost = width * height * bytesPerPixel
        mem.setObject(image, forKey: url as NSURL, cost: cost)
    }
}
