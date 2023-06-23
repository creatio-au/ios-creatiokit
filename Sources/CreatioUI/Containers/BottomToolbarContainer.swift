//
//  BottomToolbarContainer.swift
//
//
//  Created by Davis Allie on 22/7/2022.
//

import Combine
import SwiftUI

fileprivate let globalKeyboardPublisher: AnyPublisher<(Bool, Animation), Never> =
    Publishers.Merge(
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in
                var animation: Animation = .default
                if let info = notification.userInfo,
                   let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                   let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                   let curve = UIView.AnimationCurve(rawValue: curveValue) {
                    switch curve {
                    case .linear:
                        animation = .linear(duration: duration)
                    case .easeIn:
                        animation = .easeIn(duration: duration)
                    case .easeOut:
                        animation = .easeOut(duration: duration)
                    case .easeInOut:
                        animation = .easeInOut(duration: duration)
                    @unknown default:
                        break
                    }
                }
                
                return (true, animation)
            },
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { notification in
                var animation: Animation = .default
                if let info = notification.userInfo,
                   let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                   let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                   let curve = UIView.AnimationCurve(rawValue: curveValue) {                    
                    switch curve {
                    case .linear:
                        animation = .linear(duration: duration)
                    case .easeIn:
                        animation = .easeIn(duration: duration)
                    case .easeOut:
                        animation = .easeOut(duration: duration)
                    case .easeInOut:
                        animation = .easeInOut(duration: duration)
                    @unknown default:
                        break
                    }
                }
                
                return (false, animation)
            }
    )
    .eraseToAnyPublisher()

public struct BottomToolbarContainer<Content: View, Toolbar: View>: View {
    
    let content: Content
    let toolbar: Toolbar
    
    public init(@ViewBuilder content: () -> Content, @ViewBuilder toolbar: () -> Toolbar) {
        self.content = content()
        self.toolbar = toolbar()
    }
    
    @State private var keyboardVisible = false
    
    public var body: some View {
        ScrollView {
            content
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !keyboardVisible {
                VStack(spacing: 0) {
                    Divider()
                    
                    toolbar
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onReceive(globalKeyboardPublisher) { visible, animation in
            withAnimation(animation) {
                keyboardVisible = visible
            }
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Keyboard") {
                            
                        }
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
