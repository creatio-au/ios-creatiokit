//
//  AdaptiveHStack.swift
//  
//
//  Created by Davis Allie on 18/6/2022.
//

import SwiftUI

public struct AdaptiveHStack<Content: View>: View {
    
    public init(spacing: CGFloat? = nil, verticalAlignment: VerticalAlignment = .center, horizontalAlignment: HorizontalAlignment = .center, conditionClosure: ((UserInterfaceSizeClass?, DynamicTypeSize) -> Bool)? = nil, @ViewBuilder content: @escaping (Bool) -> Content) {
        self.spacing = spacing
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.conditionClosure = conditionClosure
        self.content = content
    }
    
    public init(spacing: CGFloat? = nil, verticalAlignment: VerticalAlignment = .center, horizontalAlignment: HorizontalAlignment = .center, condition: @autoclosure @escaping () -> Bool, @ViewBuilder content: @escaping (Bool) -> Content) {
        self.init(
            spacing: spacing,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            conditionClosure: { _, _ in
                condition()
            },
            content: content
        )
    }
    
    private var conditionClosure: ((UserInterfaceSizeClass?, DynamicTypeSize) -> Bool)?
    @ViewBuilder private var content: (Bool) -> Content
    private var spacing: CGFloat? = nil
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    
    @ViewBuilder
    public var body: some View {
        if isVertical {
            VStack(alignment: horizontalAlignment, spacing: spacing) {
                content(!isVertical)
            }
        } else {
            HStack(alignment: verticalAlignment, spacing: spacing) {
                content(!isVertical)
            }
        }
    }
    
    private var isVertical: Bool {
        if let customConditionClosure = conditionClosure {
            return customConditionClosure(horizontalSizeClass, typeSize)
        } else {
            return typeSize.isAccessibilitySize || horizontalSizeClass == .compact
        }
    }
    
}

struct AdaptiveHStack_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
