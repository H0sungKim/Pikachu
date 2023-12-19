//
//  UIImage+Ext.swift
//  Pikachu
//
//  Created by 김기훈 on 2023/12/08.
//

import UIKit

extension UIImage {
    func duplicatePixelCopyScale(factor: CGFloat, backgroundColor: UIColor) -> UIImage? {
            let newSize = CGSize(width: size.width * factor, height: size.height * factor)

            UIGraphicsBeginImageContextWithOptions(newSize, true, 0.0)
            defer { UIGraphicsEndImageContext() }

            guard let context = UIGraphicsGetCurrentContext() else { return nil }

            // 새로운 이미지의 배경을 원하는 색으로 채웁니다.
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(origin: .zero, size: newSize))

            context.interpolationQuality = .high

            for y in stride(from: 0, to: newSize.height, by: 1) {
                for x in stride(from: 0, to: newSize.width, by: 1) {
                    let originalX = Int(x / factor)
                    let originalY = Int(y / factor)

                    if let pixelColor = colorAt(x: originalX, y: originalY) {
                        context.setFillColor(pixelColor.cgColor)
                        context.fill(CGRect(x: x, y: y, width: 1.0, height: 1.0))
                    }
                }
            }

            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
    private func colorAt(x: Int, y: Int) -> UIColor? {
        guard let cgImage = cgImage else { return nil }
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context.data else { return nil }
        
        let offset = bytesPerRow * y + bytesPerPixel * x
        let red = CGFloat(pixelData.load(fromByteOffset: offset, as: UInt8.self)) / 255.0
        let green = CGFloat(pixelData.load(fromByteOffset: offset + 1, as: UInt8.self)) / 255.0
        let blue = CGFloat(pixelData.load(fromByteOffset: offset + 2, as: UInt8.self)) / 255.0
        let alpha = CGFloat(pixelData.load(fromByteOffset: offset + 3, as: UInt8.self)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
