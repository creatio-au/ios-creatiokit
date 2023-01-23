//
//  ColorScheme.swift
//  
//
//  Created by Davis Allie on 1/3/2022.
//

import SwiftUI

extension ColorScheme {
    
    var traitCollection: UITraitCollection {
        switch self {
        case .light:
            return UITraitCollection(userInterfaceStyle: .light)
        case .dark:
            return UITraitCollection(userInterfaceStyle: .dark)
        @unknown default:
            return UITraitCollection(userInterfaceStyle: .unspecified)
        }
    }
    
}
