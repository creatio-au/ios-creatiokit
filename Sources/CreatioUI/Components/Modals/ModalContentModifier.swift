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
    
    @State private var viewController: UIViewController?
    @State private var presentedViewController: UIViewController?
    
    init(isPresented: Binding<Bool>, configuration: ModalConfiguration, @ViewBuilder _ contents: () -> ModalContent) {
        self._isPresented = isPresented
        self.configuration = configuration
        self.contents = contents()
    }
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { presented in
                if presented {
                    let wrappedContents = ModalContents(isPresented: $isPresented, configuration: configuration) {
                        contents
                    }
                    
                    let host = UIHostingController(rootView: wrappedContents)
                    host.modalPresentationStyle = .overFullScreen
                    host.view.backgroundColor = .clear
                    presentedViewController = host
                    
                    viewController?.present(host, animated: false)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        presentedViewController?.dismiss(animated: false)
                    }
                }
            }
            .introspectViewController { viewController in
                self.viewController = viewController
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
