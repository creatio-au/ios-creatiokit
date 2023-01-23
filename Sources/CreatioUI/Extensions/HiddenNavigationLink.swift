//
//  HiddenNavigationLink.swift
//  
//
//  Created by Davis Allie on 11/5/2022.
//

import Foundation
import SwiftUI

fileprivate struct HiddenNavigationLinkModifier<Destination: View>: ViewModifier {
    
    @Binding var isActive: Bool
    var destination: () -> Destination
    
    func body(content: Content) -> some View {
        content.background {
            NavigationLink(isActive: $isActive) {
                destination()
            } label: {
                EmptyView()
            }
        }
    }
    
}

public extension View {
    
    func hiddenNavigationLink<Destination: View>(isActive: Binding<Bool>, @ViewBuilder _ destination: @escaping () -> Destination) -> some View {
        self.modifier(HiddenNavigationLinkModifier(isActive: isActive, destination: destination))
    }
    
}
