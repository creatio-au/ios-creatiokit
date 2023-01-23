//
//  UIImage+Resize.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import UIKit

public extension UIImage {
    
    func resized(targetWidth: CGFloat) -> UIImage {
        guard size.width > targetWidth else {
            // If we are trying to resize up then skip processing and return existing image
            return self
        }
        
        let scaleFactor = targetWidth/size.width
        let targetHeight = scaleFactor*size.height
        let newSize = CGSize(width: targetWidth, height: targetHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
}
