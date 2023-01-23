//
//  ModalDismissButton.swift
//  
//
//  Created by Davis Allie on 5/4/2022.
//

import SwiftUI

public struct ModalDismissButton: UIViewRepresentable {
        
    let dismissAction: DismissAction
    public init(_ dismissAction: DismissAction) {
        self.dismissAction = dismissAction
    }
    
    public func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .close)
        button.addTarget(context.coordinator, action: #selector(Coordinator.didTapButton), for: .primaryActionTriggered)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }
    
    public func updateUIView(_ uiView: UIButton, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(dismissAction: dismissAction)
    }
    
    public class Coordinator: NSObject {
        var dismissAction: DismissAction
        fileprivate init(dismissAction: DismissAction) {
            self.dismissAction = dismissAction
        }
        
        @objc func didTapButton() {
            dismissAction()
        }
    }
    
}
