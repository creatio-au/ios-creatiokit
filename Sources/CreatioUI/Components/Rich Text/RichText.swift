//
//  RichText.swift
//
//
//  Created by Davis Allie on 1/3/2022.
//

import SwiftUI

public struct RichText<Placeholder: View>: View {
    
    let html: String
    let placeholder: Placeholder
    
    var configuration = RichTextConfiguration()
    
    @State private var dynamicHeight: Double = .zero
    
    public init(html: String, placeholder: () -> Placeholder) {
        self.html = html
        self.placeholder = placeholder()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            Webview(
                dynamicHeight: configuration.animateChanges ? $dynamicHeight.animation() : $dynamicHeight,
                html: html,
                configuration: configuration
            )
            .frame(height: dynamicHeight)
            
            if self.dynamicHeight == 0 {
                placeholder
            }
        }
    }
}

public extension RichText where Placeholder == ProgressView<EmptyView, EmptyView> {
    init(html: String) {
        self.html = html
        self.placeholder = ProgressView()
    }
}


struct RichText_Previews: PreviewProvider {
    private static let exampleHTML = """
    <h1>Heading 1</h1>
    <h2>Heading 2</h2>
    <h3>Heading 3</h3>
    <h4>Heading 4</h4>
    <h5>Heading 5</h5>
    <h6>Heading 6</h6>
    <p>Paragraph body</p>
    <p><strong>Bold body</strong></p>
    <ol>
        <li>Ordered list item 1</li>
        <li>Ordered list item 2</li>
        <li>Ordered list item 3</li>
    </ol>
    <ul>
        <li>Unordered list item 1</li>
        <li>Unordered list item 2</li>
        <li>Unordered list item 3</li>
    </ul>
    <a href=\"https://google.com\">Some link</a>
    """
    
    static var previews: some View {
        ScrollView {
            RichText(html: exampleHTML)
            
            Divider()
            Text("Bottom of rich content")
        }
    }
}


