//
//  KeyboardAvoidingScrollView.swift
//  
//
//  Created by Davis Allie on 8/6/2022.
//

import SwiftUI
import UIKit

public struct KeyboardAvoidingScrollView<Content: View>: UIViewRepresentable {
    
    let content: Content
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let scroll = UIScrollView()
        let host = _UIHostingView(rootView: content)
        host.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(host)
        
        scroll.contentInsetAdjustmentBehavior = .always
        NSLayoutConstraint.activate([
            scroll.frameLayoutGuide.leadingAnchor.constraint(equalTo: host.leadingAnchor),
            scroll.frameLayoutGuide.trailingAnchor.constraint(equalTo: host.trailingAnchor),
            scroll.contentLayoutGuide.topAnchor.constraint(equalTo: host.topAnchor),
            scroll.contentLayoutGuide.bottomAnchor.constraint(equalTo: host.bottomAnchor)
        ])
        
        context.coordinator.setScrollView(scroll)
        return scroll
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setNeedsLayout()
        uiView.layoutIfNeeded()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public class Coordinator: NSObject, UIScrollViewDelegate {
        
        private weak var scrollView: UIScrollView?
        
        func setScrollView(_ scrollView: UIScrollView) {
            self.scrollView = scrollView
            scrollView.delegate = self
            
            NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        
        @objc private func handle(notification: Notification) {
            guard let info = notification.userInfo, let rect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, let scroll = scrollView, let window = scroll.window else {
                return
            }
            
            let endFrame = rect// = scroll.convert(rect, to: window)
            print(endFrame)
            if notification.name == UIResponder.keyboardWillHideNotification {
                scroll.contentInset = .zero
            } else {
                scroll.contentInset.bottom = endFrame.height - scroll.safeAreaInsets.bottom
            }
            scroll.scrollIndicatorInsets = scroll.contentInset
            
            if let responder = scrollView?.firstResponder, notification.name != UIResponder.keyboardWillHideNotification {
                //var scrollOffset: CGFloat = endFrame.height //CGFloat = 20 // Base line height of 20
                //scrollOffset -= endFrame.height // Adjust for keyboard height
                
                let frame = scroll.convert(responder.frame.origin, from: responder)
                print(frame)
                var scrollOffset = frame.y // Scroll to at least top of responder view
                
                if let textView = responder as? UITextView, let selection = textView.selectedTextRange, let selectionRect = textView.selectionRects(for: selection).first {
                    scrollOffset += selectionRect.rect.height // Scroll to current selection (most likely insertion point)
                    print(selectionRect)
                } else {
                    scrollOffset += 20
                }
                
                scrollOffset -= (scroll.frame.height - endFrame.height)
                
                scroll.setContentOffset(.init(x: 0, y: scrollOffset), animated: true)
            }
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            print(scrollView.contentOffset.y)
        }
        
    }
    
}

fileprivate extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
