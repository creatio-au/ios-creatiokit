//
//  OverflowScrollView.swift
//  
//
//  Created by Davis Allie on 13/4/2022.
//

import SwiftUI

public struct OverflowScrollView<Content>: View where Content : View {
    /// The scroll view's content.
    public var content: Content

    /// The scrollable axes of the scroll view.
    ///
    /// The default value is ``Axis/vertical``.
    public var axes: Axis.Set

    /// A value that indicates whether the scroll view displays the scrollable
    /// component of the content offset, in a way that's suitable for the
    /// platform.
    ///
    /// The default is `true`.
    public var showsIndicators: Bool
    
    /// A value that indicates if the scroll view has overflowed and is
    /// scrollable vertically.
    ///
    /// Use is an optional binding to be able to detect the scrollable
    /// status in the parent view.
    public var isScrollingVertically: Binding<Bool>

    /// Creates a new instance that's scrollable in the direction of the given
    /// axis and can show indicators while scrolling if the
    /// Content's size is greater than the ScrollView's.
    ///
    /// - Parameters:
    ///   - axes: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset, in a way
    ///     suitable for the platform. The default value for this parameter is
    ///     `true`.
    ///
    ///   - content: The view builder that creates the scrollable view.
    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, isScrollingVertically: Binding<Bool> = .constant(false), @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.isScrollingVertically = isScrollingVertically
        self.content = content()
    }

    @State private var fitsVertically = false
    @State private var fitsHorizontally = false

    var activeScrollingDirections: Axis.Set {
        axes.intersection((fitsVertically ? [] : Axis.Set.vertical).union(fitsHorizontally ? [] : Axis.Set.horizontal))
    }

    public var body: some View {
        GeometryReader { geometryReader in
            ScrollView(activeScrollingDirections, showsIndicators: showsIndicators) {
                content
                    .background(
                        GeometryReader {
                            // calculate size by consumed background and store in
                            // view preference
                            Color.clear.preference(
                                key: ViewSizeKey.self,
                                value: $0.frame(in: .local).size
                            )
                        }
                    )
            }
            .onPreferenceChange(ViewSizeKey.self) {
                fitsVertically = $0.height <= geometryReader.size.height
                fitsHorizontally = $0.width <= geometryReader.size.width
                
                isScrollingVertically.wrappedValue = !fitsVertically
            }
        }
    }

    private struct ViewSizeKey: PreferenceKey {
        static var defaultValue: CGSize { .zero }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            let next = nextValue()
            value = CGSize(
                width: value.width + next.width,
                height: value.height + next.height
            )
        }
    }
}

struct ScrollViewIfNeeded_Previews: PreviewProvider {
    static var previews: some View {
        OverflowScrollView {
            Text("Fits")
                .background(Color.blue)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Fits")

        OverflowScrollView([.horizontal, .vertical]) {
            VStack {
                ForEach(1...50, id: \.self) {
                    Text("\($0)")
                        .frame(width: 30, height: 30)
                        .background(Color.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Fits horizontally")

        OverflowScrollView([.horizontal, .vertical]) {
            HStack {
                ForEach(1...50, id: \.self) {
                    Text("\($0)")
                        .frame(width: 30, height: 30)
                        .background(Color.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Fits vertically")

        OverflowScrollView([.horizontal, .vertical]) {
            HStack {
                ForEach(1...50, id: \.self) {
                    Text("\($0)")
                        .frame(width: 30, height: 30 * CGFloat($0))
                        .background(Color.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Does not fit")

        OverflowScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(1...50, id: \.self) {
                    Text("\($0)")
                        .frame(width: 30, height: 30 * CGFloat($0))
                        .background(Color.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Only horizontal scrolling enabled")

        OverflowScrollView {
            HStack {
                ForEach(1...50, id: \.self) {
                    Text("\($0)")
                        .frame(width: 30, height: 30 * CGFloat($0))
                        .background(Color.blue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Only vertical scrolling enabled")
    }
}
