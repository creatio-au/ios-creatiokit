//
//  UIImage+Normalize.swift
//  
//
//  Created by Davis Allie on 2/4/2022.
//

import UIKit

public extension UIImage {
    
    func normalized() -> UIImage {
        guard imageOrientation != .up else {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized!
    }
    
}
