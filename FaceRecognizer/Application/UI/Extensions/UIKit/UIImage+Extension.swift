//
//  UIImage+Extension.swift
//
//
//  Created by Aleksandr Mikhaylov on 15.04.2024.
//

import UIKit

public extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        
        let widthRatio = size.width / targetSize.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize, format: format)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    func switchOrientationToUp() -> UIImage {
        guard let cgImage else { return self }
        
        let originalWidth = cgImage.width
        let originalHeight = cgImage.height
        let bitsPerComponent = cgImage.bitsPerComponent
        let orientation = CGImagePropertyOrientation(imageOrientation)
        
        let bitmapInfo = cgImage.bitmapInfo
        
        guard let colorSpace = cgImage.colorSpace else {
            return self
        }
        
        var degreesToRotate: Double
        var swapWidthHeight: Bool
        var mirrored: Bool
        
        switch orientation {
        case .up:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = false
        case .upMirrored:
            degreesToRotate = 0.0
            swapWidthHeight = false
            mirrored = true
        case .left:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = false
        case .rightMirrored:
            degreesToRotate = 90.0
            swapWidthHeight = true
            mirrored = true
        case .down:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = false
        case .downMirrored:
            degreesToRotate = 180.0
            swapWidthHeight = false
            mirrored = true
        case .right:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = false
        case .leftMirrored:
            degreesToRotate = -90.0
            swapWidthHeight = true
            mirrored = true
        }
        let radians = degreesToRotate * Double.pi / 180.0
        
        var width: Int
        var height: Int
        
        if swapWidthHeight {
            width = originalHeight
            height = originalWidth
        } else {
            width = originalWidth
            height = originalHeight
        }
        
        let contextRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        contextRef?.translateBy(x: CGFloat(width) / 2.0, y: CGFloat(height) / 2.0)
        if mirrored {
            contextRef?.scaleBy(x: -1.0, y: 1.0)
        }
        contextRef?.rotate(by: CGFloat(radians))
        if swapWidthHeight {
            contextRef?.translateBy(x: -CGFloat(height) / 2.0, y: -CGFloat(width) / 2.0)
        } else {
            contextRef?.translateBy(x: -CGFloat(width) / 2.0, y: -CGFloat(height) / 2.0)
        }
        
        contextRef?.draw(cgImage, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(originalWidth), height: CGFloat(originalHeight)))

        if let newcgImage = contextRef?.makeImage() {
            return UIImage(cgImage: newcgImage, scale: scale, orientation: .up)
        }
        
        return self
    }
}
