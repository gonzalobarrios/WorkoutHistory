//
//  ImageCache.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation
import UIKit

protocol ImageCacheProtocol {
    func image(for url: URL) -> UIImage?
    func insert(_ image: UIImage, for url: URL)
}

class ImageCache: ImageCacheProtocol {
    static let shared = ImageCache()

    private let cache: NSCache<NSURL, UIImage>

    private init() {
        cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200
        cache.totalCostLimit = 1024 * 1024 * 100
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insert(_ image: UIImage, for url: URL) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let cost = imageData.count
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }
}
