//
//  ImageLoader.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader(
        imageCache: ImageCache.shared,
        imageFetcher: ImageFetcher(),
        diskCache: DiskCache()
    )

    private let imageCache: ImageCacheProtocol
    private let imageFetcher: ImageFetcherProtocol
    private let diskCache: DiskCacheProtocol

    init(
        imageCache: ImageCacheProtocol,
        imageFetcher: ImageFetcherProtocol,
        diskCache: DiskCacheProtocol
    ) {
        self.imageCache = imageCache
        self.imageFetcher = imageFetcher
        self.diskCache = diskCache
    }

    func loadImage(from url: URL) async throws -> UIImage {
        if let cachedImage = imageCache.image(for: url) {
            print("Loaded from memory cache")
            return cachedImage
        }

        if let diskImage = diskCache.loadImageFromDisk(for: url) {
            imageCache.insert(diskImage, for: url)
            print("Loaded from disk cache")
            return diskImage
        }

        let image = try await imageFetcher.fetchImage(from: url)
        imageCache.insert(image, for: url)
        diskCache.saveImageToDisk(image, for: url)
        print("Loaded from network")
        return image
    }
}

enum ImageLoaderError: Error {
    case invalidImageData
}
