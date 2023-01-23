//
//  StatusBarStyle.swift
//  
//
//  Created by Davis Allie on 15/4/2022.
//

import SwiftUI

struct StatusBarStyleModifier: ViewModifier {
    
    var style: UIStatusBarStyle
    var resetToDefault = false
    var resetToPrevious = false
    @State var previousStyle: UIStatusBarStyle = .default
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                previousStyle = UIApplication.shared.statusBarStyle
                UIApplication.shared.setStatusBarStyle(style, animated: true)
            }
            .onDisappear {
                if resetToDefault {
                    UIApplication.shared.setStatusBarStyle(.default, animated: true)
                } else if resetToPrevious {
                    UIApplication.shared.setStatusBarStyle(previousStyle, animated: true)
                }
            }
    }
    
}

public extension View {
    
    func statusBarStyle(_ style: UIStatusBarStyle, resetToDefault: Bool = false, resetToPrevious: Bool = false) -> some View {
        self.modifier(StatusBarStyleModifier(style: style, resetToDefault: resetToDefault, resetToPrevious: resetToPrevious))
    }
    
}
