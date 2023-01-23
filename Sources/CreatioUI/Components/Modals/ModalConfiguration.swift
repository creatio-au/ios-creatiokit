//
//  ModalConfiguration.swift
//  
//
//  Created by Davis Allie on 5/6/2022.
//

import SwiftUI

public struct ModalConfiguration {
    
    public enum ContentStyle {
        case bottomSheet, alert, topBanner, bottomBanner
    }
    
    public enum BackgroundStyle {
        case faded(opacity: Double), material(Material)
    }
    
    var contentStyle: ContentStyle
    var backgroundStyle: BackgroundStyle
    var backgroundDismissable: Bool
    
    public init(contentStyle: ContentStyle, backgroundStyle: BackgroundStyle, backgroundDismissable: Bool) {
        self.contentStyle = contentStyle
        self.backgroundStyle = backgroundStyle
        self.backgroundDismissable = backgroundDismissable
    }
    
    public static let bottomSheet = ModalConfiguration(contentStyle: .bottomSheet, backgroundStyle: .faded(opacity: 0.5), backgroundDismissable: true)
    public static let alert = ModalConfiguration(contentStyle: .alert, backgroundStyle: .faded(opacity: 0.5), backgroundDismissable: false)
    
}
