//
//  UIImage + extension.swift
//  myChat
//
//  Created by Мария Хатунцева on 26.10.2022.
//

import UIKit

extension UIImage {
    
    func applyFilter(_ filterName: String) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self)
        let filter = CIFilter(name: filterName)
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        guard let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) else {
            return self
        }
        return UIImage(cgImage: filteredImageRef)
    }
    
        func toPngString() -> String? {
            let data = self.pngData()
            return data?.base64EncodedString(options: .endLineWithLineFeed)
        }
        func toJpegString(compressionQuality cq: CGFloat) -> String? {
            let data = self.jpegData(compressionQuality: cq)
            return data?.base64EncodedString(options: .endLineWithLineFeed)
        }   
}
