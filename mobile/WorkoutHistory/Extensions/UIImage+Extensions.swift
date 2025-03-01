//
//  UIImage+Extensions.swift
//  WorkoutHistory
//
//  Created by Gonzalo on 2/28/25.
//

import UIKit
import SwiftUI

extension UIImage {
    func resized(to maxKB: Int) -> Data? {
        let maxBytes = maxKB * 1024
        var compression: CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compression)

        while let currentSize = imageData?.count, currentSize > maxBytes, compression > 0.1 {
            compression -= 0.1
            imageData = self.jpegData(compressionQuality: compression)
        }
        return imageData
    }

    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: width, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.7)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
