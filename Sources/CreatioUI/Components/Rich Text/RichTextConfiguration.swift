//
//  RichTextConfiguration.swift
//  
//
//  Created by Davis Allie on 1/3/2022.
//

import SwiftUI
import UIKit

public enum RichTextLinkBehaviour {
    case externalBrowser, inAppWebView(readerMode: Bool)
}

internal struct RichTextConfiguration {
    var animateChanges: Bool = true
    var imageCornerRadius: CGFloat = 0
    var textSize: CGFloat = 17
    var font: UIFont?
    var linkBehaviour: RichTextLinkBehaviour = .externalBrowser
    var linkColor: Color = .accentColor
}

/**
 Public extension for modifier methods to change config values
 */
public extension RichText {
    func animateChanges(_ animateChanges: Bool) -> Self {
        var result = self
        result.configuration.animateChanges = animateChanges
        return result
    }
    
    func imageCornerRadius(_ imageCornerRadius: Double) -> Self {
        var result = self
        result.configuration.imageCornerRadius = CGFloat(imageCornerRadius)
        return result
    }
    
    func textSize(_ textSize: CGFloat) -> Self {
        var result = self
        result.configuration.textSize = textSize
        return result
    }
    
    func font(_ font: UIFont) -> Self {
        var result = self
        result.configuration.font = font
        return result
    }
    
    func linkBehaviour(_ linkBehaviour: RichTextLinkBehaviour) -> Self {
        var result = self
        result.configuration.linkBehaviour = linkBehaviour
        return result
    }
    
    func linkColor(_ linkColor: Color) -> Self {
        var result = self
        result.configuration.linkColor = linkColor
        return result
    }
}
