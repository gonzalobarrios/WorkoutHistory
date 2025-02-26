//
//  DiskCache.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation
import UIKit

protocol DiskCacheProtocol {
    func loadImageFromDisk(for url: URL) -> UIImage?
    func saveImageToDisk(_ image: UIImage, for url: URL)
}

class DiskCache: DiskCacheProtocol {
    private let fileManager = FileManager.default
    private let diskCacheDirectory: URL

    init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.diskCacheDirectory = cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
        if !fileManager.fileExists(atPath: diskCacheDirectory.path) {
            try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
        }
    }

    func loadImageFromDisk(for url: URL) -> UIImage? {
        let fileURL = diskCacheDirectory.appendingPathComponent(urlToFilename(url))
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    func saveImageToDisk(_ image: UIImage, for url: URL) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileURL = diskCacheDirectory.appendingPathComponent(urlToFilename(url))
        try? data.write(to: fileURL)
        
        Task { await cleanOldImages(maxSizeMB: 500) }
    }

    private func urlToFilename(_ url: URL) -> String {
        let hash = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
        return hash.replacingOccurrences(of: "/", with: "_")
    }
    
    func cleanOldImages(maxSizeMB: Int = 500) async {
        let files = (try? fileManager.contentsOfDirectory(at: diskCacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey])) ?? []
        
        var totalSize = 0
        var fileAttributes: [(url: URL, size: Int, date: Date)] = []
        
        for file in files {
            let attributes = try? file.resourceValues(forKeys: [.contentModificationDateKey, .fileSizeKey])
            if let size = attributes?.fileSize, let date = attributes?.contentModificationDate {
                totalSize += size
                fileAttributes.append((url: file, size: size, date: date))
            }
        }

        if totalSize > maxSizeMB * 1_000_000 {
            let sortedFiles = fileAttributes.sorted { $0.date < $1.date }
            for file in sortedFiles {
                try? fileManager.removeItem(at: file.url)
                totalSize -= file.size
                if totalSize <= maxSizeMB * 1_000_000 { break }
            }
        }
    }
}
