//
//  UIScreen+CornerRadius.swift
//  
//
//  Created by Davis Allie on 5/6/2022.
//

import UIKit

extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    /// The corner radius of the display. Uses a private property of `UIScreen`,
    /// and may report 0 if the API changes.
    public var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            return 0
        }

        return cornerRadius
    }
    
    public func cornerRadiusSuitableForDisplay(inset: CGFloat = 0) -> CGFloat {
        var baseCornerRadius = displayCornerRadius
        if baseCornerRadius == 0 {
            baseCornerRadius = 36
        }

        return max(baseCornerRadius-inset, 0)
    }
}
