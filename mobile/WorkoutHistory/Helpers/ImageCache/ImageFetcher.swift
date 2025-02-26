//
//  ImageFetcher.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/26/25.
//

import Foundation
import UIKit

protocol ImageFetcherProtocol {
    func fetchImage(from url: URL) async throws -> UIImage
}

class ImageFetcher: ImageFetcherProtocol {
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            throw ImageLoaderError.invalidImageData
        }
        return image
    }
}
