//
//  ModalContentModifier.swift
//  
//
//  Created by Davis Allie on 5/6/2022.
//

import Introspect
import SwiftUI

struct ModalContentModifier<ModalContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    var configuration: ModalConfiguration
    var contents: ModalContent
    
    @State private var windowScene: UIWindowScene?
    @State private var previousWindow: UIWindow?
    @State private var presentedWindow: UIWindow?
    
    init(isPresented: Binding<Bool>, configuration: ModalConfiguration, @ViewBuilder _ contents: () -> ModalContent) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.contents = contents()
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { presented in
                if presented {
                    guard let windowScene else {
                        return
                    }
                    
                    let wrappedContents = ModalContents(isPresented: $isPresented, configuration: configuration) {
                        contents
                    }
                    
                    let window = UIWindow(windowScene: windowScene)
                    window.windowLevel = .alert
                    window.backgroundColor = .clear
                    
                    let host = UIHostingController(rootView: wrappedContents)
                    host.view.backgroundColor = .clear
                    window.rootViewController = host
                    
                    previousWindow = windowScene.keyWindow
                    window.makeKeyAndVisible()
                    presentedWindow = window
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        presentedWindow?.isHidden = true
                        presentedWindow?.removeFromSuperview()
                        presentedWindow = nil
                        
                        previousWindow?.makeKeyAndVisible()
                    }
                }
            }
            .introspectViewController { viewController in
                windowScene = viewController.view?.window?.windowScene
            }
    }
    
}

public extension View {
    
    func customAlert<Content: View>(isPresented: Binding<Bool>, @ViewBuilder _ content: () -> Content) -> some View {
        self.modifier(ModalContentModifier(isPresented: isPresented, configuration: .alert, content))
    }
    
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder _ content: () -> Content) -> some View {
        self.modifier(ModalContentModifier(isPresented: isPresented, configuration: .bottomSheet, content))
    }
    
    func customModal<Content: View>(isPresented: Binding<Bool>, configuration: ModalConfiguration, @ViewBuilder _ content: () -> Content) -> some View {
        self.modifier(ModalContentModifier(isPresented: isPresented, configuration: configuration, content))
    }
    
}
