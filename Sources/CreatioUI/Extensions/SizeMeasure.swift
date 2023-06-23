//
//  SizeMeasure.swift
//  
//
//  Created by Davis Allie on 23/6/2023.
//

import SwiftUI

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

fileprivate struct SizeMeasureModifier: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            }
            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                size = newSize
            }
    }
    
}

public extension View {
    
    func measureSize(in size: Binding<CGSize>) -> some View {
        self.modifier(SizeMeasureModifier(size: size))
    }
    
}
