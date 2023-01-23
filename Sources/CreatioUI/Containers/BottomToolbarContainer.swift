//
//  BottomToolbarContainer.swift
//  
//
//  Created by Davis Allie on 22/7/2022.
//

import Combine
import SwiftUI

public struct BottomToolbarContainer<Content: View, Toolbar: View>: View, KeyboardReadable {
    
    // For some reason the geometry size is correct but
    // the scrollview inset needs additional points
    // to line up correctly in some layouts
    let extraPadding: CGFloat
    let content: Content
    let toolbar: Toolbar
    
    public init(extraPadding: CGFloat = 0.0, @ViewBuilder content: () -> Content, @ViewBuilder toolbar: () -> Toolbar) {
        self.extraPadding = extraPadding
        self.content = content()
        self.toolbar = toolbar()
    }
    
    @State private var isInNavigationView = false
    @State private var keyboardVisible = false
    
    // For some reason the geometry size is correct but
    // the scrollview inset needs an additional 20 points
    // to line up correctly when in a navigation view
    @State private var toolbarHeight: CGFloat = 0.0
    
    public var body: some View {
        ZStack {
            ScrollView {
                content
            }
            .padding(.bottom, keyboardVisible ? 0 : toolbarHeight + extraPadding)
            .onReceive(keyboardPublisher) { isVisible in
                keyboardVisible = isVisible
            }
            
            VStack(spacing: 0) {
                Divider()
                
                toolbar
                    .background {
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    toolbarHeight = geometry.size.height
                                }
                        }
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.keyboard)
        }
    }
    
}

struct BottomToolbarContainer_Previews: PreviewProvider {
    
    struct Preview: View {
        @State private var input = ""
        
        var body: some View {
            BottomToolbarContainer {
                VStack {
                    ForEach(0..<30) { i in
                        TextField("Field", text: $input)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .padding()
            } toolbar: {
                HStack {
                    Button {
                        
                    } label: {
                        Text("Button 1")
                            .padding(.vertical, 40)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        
                    } label: {
                        Text("Button 2")
                            .padding(.vertical, 40)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Material.bar)
            }
        }
    }
    
    static var previews: some View {
        NavigationView {
            Preview()
                .navigationTitle("Title")
        }
        
        Preview()
    }
}

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
