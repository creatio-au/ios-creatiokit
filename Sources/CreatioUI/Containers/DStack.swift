//
//  DStack.swift
//  
//
//  Created by Davis Allie on 23/6/2023.
//

import SwiftUI

public enum LayoutDirection {
    case vertical, horizontal
}

/**
 Dynamic stack that can flexibly change between vertical and horizontal directions
 */
public struct DStack<Content: View>: View {
    
    public init(spacing: CGFloat? = nil, verticalAlignment: VerticalAlignment = .center, horizontalAlignment: HorizontalAlignment = .center, conditionClosure: @escaping ((UserInterfaceSizeClass, DynamicTypeSize) -> LayoutDirection), @ViewBuilder content: @escaping (LayoutDirection) -> Content) {
        self.spacing = spacing
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.conditionClosure = conditionClosure
        self.content = content
    }
    
    public init(spacing: CGFloat? = nil, verticalAlignment: VerticalAlignment = .center, horizontalAlignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping (LayoutDirection) -> Content) {
        self.init(
            spacing: spacing,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            conditionClosure: { sizeClass, typeSize in
                if typeSize.isAccessibilitySize || sizeClass == .compact {
                    return .vertical
                } else {
                    return .horizontal
                }
            },
            content: content
        )
    }
    
    public init(spacing: CGFloat? = nil, verticalAlignment: VerticalAlignment = .center, horizontalAlignment: HorizontalAlignment = .center, direction: @autoclosure @escaping () -> LayoutDirection, @ViewBuilder content: @escaping (LayoutDirection) -> Content) {
        self.init(
            spacing: spacing,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            conditionClosure: { _, _ in
                direction()
            },
            content: content
        )
    }
    
    private var conditionClosure: ((UserInterfaceSizeClass, DynamicTypeSize) -> LayoutDirection)
    
    @ViewBuilder private var content: (LayoutDirection) -> Content
    private var spacing: CGFloat? = nil
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dynamicTypeSize) private var typeSize
    
    @ViewBuilder
    public var body: some View {
        let direction = conditionClosure(horizontalSizeClass ?? .compact, typeSize)
        
        if #available(iOS 16.0, *) {
            let layout = contentLayout(forDirection: direction)
            layout {
                content(direction)
            }
        } else {
            switch direction {
            case .vertical:
                VStack(alignment: horizontalAlignment, spacing: spacing) {
                    content(direction)
                }
            case .horizontal:
                HStack(alignment: verticalAlignment, spacing: spacing) {
                    content(direction)
                }
            }
        }
    }
    
    @available(iOS 16.0, *)
    private func contentLayout(forDirection direction: LayoutDirection) -> AnyLayout {
        switch direction {
        case .vertical:
            return AnyLayout(VStackLayout(alignment: horizontalAlignment, spacing: spacing))
        case .horizontal:
            return AnyLayout(HStackLayout(alignment: verticalAlignment, spacing: spacing))
        }
    }
    
}

struct DStackStack_Previews: PreviewProvider {
    static var previews: some View {
        DStack(direction: .horizontal) { _ in
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
        
        DStack(direction: .vertical) { _ in
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }
    }
}
