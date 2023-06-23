//
//  ModalContents.swift
//  
//
//  Created by Davis Allie on 5/6/2022.
//

import SwiftUI

public struct ModalContents<Content: View>: View {
    
    @Binding var isPresented: Bool
    var configuration: ModalConfiguration
    var contents: Content
    
    public init(isPresented: Binding<Bool>, configuration: ModalConfiguration, @ViewBuilder _ contents: () -> Content) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.contents = contents()
    }
    
    @State private var isShowingBackground = false
    @State private var isShowingContent = false
    private let contentAnimationDelay = 0.2
    
    public var body: some View {
        ZStack {
            background
                .opacity(isShowingBackground ? 1.0 : 0.0)
                .zIndex(1)
            
            if isShowingContent {
                mainContents
                    .zIndex(2)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                isShowingBackground = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(contentAnimation) {
                    isShowingContent = true
                }
            }
        }
        .onChange(of: isPresented) { presented in
            if !isPresented {
                withAnimation {
                    isShowingBackground = false
                    isShowingContent = false
                }
            }
        }
    }
    
    @ViewBuilder
    private var background: some View {
        Group {
            switch configuration.backgroundStyle {
            case .faded(let opacity):
                Color.black.opacity(opacity)
            case .material(let material):
                Rectangle()
                    .background(material)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            if configuration.backgroundDismissable {
                isPresented = false
            }
        }
    }
    
    @ViewBuilder
    private var mainContents: some View {
        switch configuration.contentStyle {
        case .bottomSheet:
            contents
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: UIScreen.main.cornerRadiusSuitableForDisplay(inset: 4), style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(4)
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
        case .alert:
            contents
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(Color(.tertiarySystemBackground))
                }
                .padding(.horizontal, 36)
                .transition(.opacity.combined(with: .scale(scale: 1.05)))
        case .topBanner:
            contents
                .frame(maxHeight: .infinity, alignment: .top)
        case .bottomBanner:
            contents
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    private var contentAnimation: Animation {
        switch configuration.contentStyle {
        case .bottomSheet:
            return .interactiveSpring()
        case .alert:
            return .easeInOut(duration: 0.2)
        default:
            return .easeOut(duration: 0.2)
        }
    }
    
}

struct ModalContents_Previews: PreviewProvider {
    static var exampleContent: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
            
            Text("Content")
                .font(.body)
            
            Button("Action") {}
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
        }
    }
    
    struct OverlayPreview: View {
        
        @State private var presented = false
        
        var body: some View {
            ZStack {
                Color.red
                
                Button("Present") {
                    withAnimation {
                        presented = true
                    }
                }
                .customAlert(isPresented: $presented) {
                    exampleContent
                }
            }
        }
        
    }
    
    static var previews: some View {
        OverlayPreview()
        
        Group {
            ModalContents(isPresented: .constant(true), configuration: .bottomSheet) {
                exampleContent
            }
            ModalContents(isPresented: .constant(true), configuration: .bottomSheet) {
                exampleContent
            }
            .previewDevice("iPhone SE (3rd generation)")
        }
        
        ModalContents(isPresented: .constant(true), configuration: .alert) {
            exampleContent
        }
    }
}

fileprivate struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}
