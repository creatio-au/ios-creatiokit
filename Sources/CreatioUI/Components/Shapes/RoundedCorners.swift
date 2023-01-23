//
//  RoundedCorners.swift
//  
//
//  Created by Davis Allie on 13/5/2022.
//

import SwiftUI
import UIKit

public struct RoundedCorners: Shape {

    var cornerRadius: CGFloat
    var style: RoundedCornerStyle
    var corners: UIRectCorner
    
    public init(cornerRadius: CGFloat = 12, style: RoundedCornerStyle = .continuous, corners: UIRectCorner = .allCorners) {
        self.cornerRadius = cornerRadius
        self.style = style
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
    
}
